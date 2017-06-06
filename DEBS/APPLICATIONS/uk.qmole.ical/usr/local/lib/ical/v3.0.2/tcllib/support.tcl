# Copyright (c) 1993 by Sanjay Ghemawat
#############################################################################
# Support operations

#### Customization support ####

# Load the specified proc if it has not already been loaded
proc require {proc} {
    if ![string compare [info commands $proc] $proc] return

    global auto_index
    if [info exists auto_index($proc)] {
        uplevel #0 $auto_index($proc)
    }
}

# Redefine procedure body but keep argument list unchanged
proc redefine_proc {proc code} {
    # Resurrect argument list
    set args {}
    foreach a [info args $proc] {
        if [info default $proc $a def] {
            lappend args [list $a $def]
        } else {
            lappend args $a
        }
    }
    proc $proc $args $code
}

# Append code to procedure body
proc after_proc {proc code} {
    redefine_proc $proc "[info body $proc]\n$code"
}

# Prepend code to procedure body
proc before_proc {proc code} {
    redefine_proc $proc "$code\n[info body $proc]"
}

#### Special options ####
proc tcllib_load_options {} {
    if [string match *color* [winfo screenvisual .]] {
        set small_bd 1
        set big_bd 2
    } else {
        set small_bd 2
        set big_bd 3
    }

    option add *Inset.BorderWidth $big_bd startupFile
    foreach spec {
        Pane Entry Scrollbar Button Checkbutton Radiobutton Menubutton Menu
    } {
        option add *$spec.BorderWidth $small_bd startupFile
    }

    option add *Pane.Relief             raised  startupFile
    option add *Inset.Relief            groove  startupFile
    option add *Entry.Relief            sunken  startupFile
    option add *Scrollbar.Relief        raised  startupFile
    option add *Button.padX             1m      startupFile
}

# effects Make frame containing buttons.
#         The created buttons are packed in a new frame called "frame".
#         "spec" is a list of button specifications.  Each specification
#         is a list with two elements.  The first element is the text
#         string for the button, and the second element is the command
#         to which the created button is bound.
#         "default" should be an index into the specification list.  The
#         corresponding button is wrapped inside a border to indicate that
#         it is the default.

proc make_buttons {frame default spec} {
    frame $frame -class Pane

    set i 0
    foreach s $spec {
        set str [lindex $s 0]
        set cmd [lindex $s 1]

        if {$i == $default} {
            frame $frame.def$i -relief sunken -bd 1
            button $frame.b$i -text $str -command $cmd
            pack $frame.b$i -in $frame.def$i -side left -padx 2m -pady 2m
            pack $frame.def$i -side left -expand 1 -padx 1m -pady 1m
        } else {
            button $frame.b$i -text $str -command $cmd
            pack $frame.b$i -side left -expand 1 -padx 3m -pady 3m
        }

        incr i
    }
}

# Set geometry so that toplevel shows up in same virtual window as leader 
proc set_geometry {leader w g} {
    if ![regexp {^([+-])([0-9]+)([+-])([0-9]+)$} $g junk sx x sy y] {
        return
    }

    if ![string compare $sx -] {
        set x [expr [winfo screenwidth $w] - $x]
    }
    if ![string compare $sy -] {
        set y [expr [winfo screenheight $w] - $y]
    }

    if ![string compare $leader {}] {
        set leader $w
    }
    set x [expr $x - [winfo vrootx $leader]]
    set y [expr $y - [winfo vrooty $leader]]
    wm geometry $w +$x+$y
}

#############################################################################
# Dialog Interaction Mechanism
#
# Commands
#
# dialog_run <leader> <window> <var>
#       requires <window> is a toplevel.
#                <leader> is either {}, or a window.
#       effects  Run dialog in <window> until global variable <var>
#                is modified.  If <leader> is {}, the dialog is
#                centered on the screen. Otherwise, the dialog is
#                centered on <leader>.

proc dialog_run {leader window var {focuswin ""}} {
    global [regsub {\(.*\)$} $var {}]

    # Wait for window geometry to be computed if possible
    update idletasks

    # Center window over leader
    if {$leader == {}} {
        set x [expr ([winfo screenwidth $window]-[winfo reqwidth $window])/2]
        set y [expr ([winfo screenheight $window]-[winfo reqheight $window])/2]
        set_geometry $leader $window +$x+$y
    } else {
        set lx [expr [winfo rootx $leader] + [winfo vrootx $leader]]
        set ly [expr [winfo rooty $leader] + [winfo vrooty $leader]]
        set x [expr $lx+[winfo width $leader]/2]
        set y [expr $ly+[winfo height $leader]/2]
        set x [expr $x-[winfo reqwidth $window]/2]
        set y [expr $y-[winfo reqheight $window]/2]
        wm geometry $window +$x+$y
    }

    wm transient $window $leader
    wm deiconify $window

    if ![string compare $focuswin {}] {set focuswin $window}
    set oldfocus [focus]
    catch {grab set $window}
    focus $focuswin
    vwait $var
    grab release $window
    catch {focus $oldfocus}
    wm withdraw $window
    update
}

#############################################################################
# Font/color query routines

# effects -  Return width of "text" in "font".  Add "pad" on each side.
proc text_width {font text {pad 0}} {
    global font_cache
    text_cache_load $font $text
    return [expr $font_cache(w:$font,$text) + 2*$pad]
}

# effects -  Return height of "text" in "font".  Add "pad" on each side.
proc text_height {font text {pad 0}} {
    global font_cache
    text_cache_load $font $text
    return [expr $font_cache(h:$font,$text) + 2*$pad]
}

# effects - Load cache with width and height of "text" rendered in "font".
proc text_cache_load {font text} {
    global font_cache
    if [info exists font_cache(w:$font,$text)] return

    # Get the width
    set f .__text_loader
    if ![winfo exists $f] {canvas $f}

    set i [$f create text 0 0 -text $text -font $font]
    set b [$f bbox $i]
    $f delete $i

    set font_cache(w:$font,$text) [expr [lindex $b 2] - [lindex $b 0] + 1]
    set font_cache(h:$font,$text) [expr [lindex $b 3] - [lindex $b 1] + 1]
}

# effects - Return true iff specified font exists.
proc font_exists {font} {
    global font_cache
    if ![info exists font_cache(exists:$font)] {
        # Have not checked this font yet.  Try to use it.
        set f .__font_loader
        if ![winfo exists $f] {label $f -text X}

        set font_cache(exists:$font) 0
        if ![catch {set i [$f configure -font $font]}] {
            set font_cache(exists:$font) 1
        }
    }

    return $font_cache(exists:$font)
}

# effects - Return true iff specified color exists.
proc color_exists {color} {
    global color_cache
    if ![info exists color_cache(exists:$color)] {
        # Have not checked this color yet.  Try to use it.
        set f .__font_loader
        if ![winfo exists $f] {label $f -text X}

        set color_cache(exists:$color) 0
        if ![catch {set i [$f configure -foreground $color]}] {
            set color_cache(exists:$color) 1
        }
    }

    return $color_cache(exists:$color)
}

#### Debugging support ####

# effects - Print stack trace on stderr
proc stack_trace {} {
    set level [info level]
    while {$level > 0} {
        set info [info level $level]
        puts stderr [join $info]
        incr level -1
    }
    puts stderr "====="
}

#### File IO ####

# effects Read contents of file and return as a string.
proc file_read {file} {
    set input [open $file r]
    if [catch {set string [read -nonewline $input]} result] {
        catch {close $input}
        error $result
    }
    catch {close $input}
    return $string
}
