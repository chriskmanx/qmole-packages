# Copyright (c) 1993 by Sanjay Ghemawat
##############################################################################
# ApptList
#
#       Maintains list of appointments for a certain date.
#
# Description
# ===========
# An AppointmentList displays appointments for a particular date.

class ApptList {name view} {
    set slot(window) $name
    set slot(view) $view
    set slot(date) [date today]
    set slot(items) ""
    set slot(width) 100
    set slot(start) 0
    set slot(finish) 24
    set slot(sel) {}

    frame $name -class ApptList
    scrollbar $name.s -orient vertical -command [list $name.c yview]
    canvas $name.c -yscrollcommand [list $name.s set]

    # Get font for this window
    set slot(font) [option get $name.c itemFont Font]
    if ![string compare $slot(font) ""] {
        set slot(font) [pref itemFont]
    }

    # Get font dimensions
    set slot(label_width) [text_width  $slot(font) "00:00AM" [pref itemPad]]
    set slot(font_height) [text_height $slot(font) "00:00AM" [pref itemPad]]

    $self background

    pack $name.s -side right -fill y
    pack $name.c -side left -expand 1 -fill both

    # Establish bindings
    $name.c bind rest <2> [list $name.c scan mark 0 %y]
    $name.c bind rest <B2-Motion> [list $name.c scan dragto 0 %y]
    $name.c bind rest <Button-1> [list $self new %y]
    bind $name.c <Configure> [list $self canvas_resize %w %h]
    bindtags $name.c [list IcalUser $name.c IcalItemEditBindings IcalItem IcalCommand]

    # Handle triggers
    trigger on add      [list $self change]
    trigger on delete   [list $self remove]
    trigger on change   [list $self change]
    trigger on text     [list $self textchange]
    trigger on flush    [list $self rescan]
    trigger on midnight [list $self rescan]
    trigger on reconfig [list $self reconfig]
    trigger on select   [list $self check_selection]
}

method ApptList set_date {date} {
    set slot(date) $date
    $self rescan
    $self scroll_default
}

# effects - Cleanup on destruction
method ApptList destructor {} {
    # We have to be very careful here about making sure callbacks do
    # not occur in the wrong place (i.e. on already deleted objects).

    # Remove triggers as soon as possible
    trigger remove add          [list $self change]
    trigger remove delete       [list $self remove]
    trigger remove change       [list $self change]
    trigger remove text         [list $self textchange]
    trigger remove flush        [list $self rescan]
    trigger remove midnight     [list $self rescan]
    trigger remove reconfig     [list $self reconfig]
    trigger remove select       [list $self check_selection]

    # Trim item list
    set list $slot(items)
    set slot(items) {}

    foreach item $list {
        catch {class_kill $slot(window.$item)}
    }

    destroy $slot(window)
}

method ApptList line_height {} {
    return $slot(font_height)
}

##############################################################################
# Internal Procedures

method ApptList reconfig {} {
    $slot(window).c delete rest
    $self background
    $self scroll_default
    $self layout
}

# effects - Create AppointmentList background
method ApptList background {} {
    set c $slot(window).c

    set slot(width) [winfo pixels $c "[cal option ItemWidth]c"]

    set width [expr $slot(label_width) + $slot(width)]
    set height [expr 48 * $slot(font_height)]

    set slot(start)  [cal option DayviewTimeStart]
    set slot(finish) [cal option DayviewTimeFinish]
    set lines [expr ($slot(finish) - $slot(start)) * 2]

    # Set canvas geometry

    $c configure\
        -width $width\
        -height [expr $lines * $slot(font_height)]\
        -confine 1\
        -scrollregion [list 0 0 $width $height]             

    # Set scrolling increment and initial position
    $c configure -xscrollincrement $slot(font_height)
    $c configure -yscrollincrement $slot(font_height)
    $c xview moveto 0
    $c yview moveto [expr $slot(start)/24]

    # Create background
    $c create rectangle 0 0 $width $height\
        -fill ""\
        -outline ""\
        -width 0\
        -tags [list bg rest]

    # Draw vertical separator line
    $c create line $slot(label_width) 0 $slot(label_width) $height\
        -fill [pref apptLineColor]\
        -tags rest

    set time 0
    for {set i 0} {$i < 48} {incr i} {
        set ypos [expr $i * $slot(font_height) - 1]

        if {($i % 2) != 0} {
            set stipple gray50
            set xpos $slot(label_width)
        } else {
            set stipple ""
            set xpos 0

            $c create text\
                [expr $slot(label_width) - [pref itemPad]]\
                [expr $ypos + $slot(font_height) - [pref itemPad]]\
                -text [time2text $time]\
                -fill [pref apptLineColor]\
                -font $slot(font)\
                -anchor se\
                -tags rest
        }

        $c create line $xpos $ypos [expr 3*$width] $ypos -stipple $stipple\
            -fill [pref apptLineColor]\
            -tags rest
        incr time 30
    }

    $c lower rest
}

method ApptList new {y} {
    # Check if something already selected on this view
    if ![catch {set i [ical_find_selection]}] {
        ical_unselect
        return
    }

    if [cal readonly] {
        error_notify [winfo toplevel $slot(window)] "Permission denied"
        return
    }

    set y [$slot(window).c canvasy $y]
    set id [appointment]
    $id starttime $slot(date) [expr "([$self time $y]/30)*30"]
    $id length 30
    $id date $slot(date)
    $id earlywarning [cal option DefaultEarlyWarning]
    $id own

    cal add $id
    ical_with_view $slot(view) {run-hook item-create $id}

    if [info exists slot(window.$id)] {
        ical_select $id $slot(date)
    }
}

method ApptList change {item} {
    if {[$item is appt] && [$item contains $slot(date)]} {
        if [info exists slot(window.$item)] {
            $slot(window.$item) read
        } else {
            # Add item
            lappend slot(items) $item
            $self make_window $item
        }
        $self layout
        return
    }

    $self remove $item
}

method ApptList textchange {item} {
    if [info exists slot(window.$item)] {
        $slot(window.$item) read
    }
}

method ApptList remove {item} {
    set list $slot(items)
    if [lremove list $item] {
        set slot(items) $list
        $self kill $item
        $self layout
    }
}

method ApptList kill {item} {
    if ![info exists slot(window.$item)] return

    catch {class_kill $slot(window.$item)}
    catch {unset slot(window.$item)}
    catch {unset slot(adjust.$item)}
}

# args are ignored - they just allow trigger to call us directly.
method ApptList rescan {args} {
    set list $slot(items)
    set slot(items) ""

    foreach appt $list {
        $self kill $appt
    }

    set list {}
    cal query $slot(date) $slot(date) item d {
        if [$item is appt] {
            lappend list $item
            $self make_window $item
        }
    }
    set slot(items) $list
    $self layout
}

method ApptList scroll_default {} {
    set min [expr 24*60]
    set max 0
    foreach a $slot(items) {
        set st [$a starttime $slot(date)]
        set fi [expr [$a starttime $slot(date)]+[$a length]-1]
        if {$st < $min} {set min $st}
        if {$fi > $max} {set max $fi}
    }

    set minLine [expr $min/30]
    set maxLine [expr $max/30]

    set h [lindex [$slot(window).c configure -height] 4]
    set windowSize [expr $h / $slot(font_height)]

    # Try to make all appointments visible
    set start [expr $slot(start) * 2]
    if {($start + $windowSize - 1) < $maxLine} {
        set start [expr $maxLine-($slot(finish) - $slot(start))*2+1]
    }
    if {$start > $minLine} {
        set start $minLine
    }

    $slot(window).c yview moveto [expr double($start)/48]
}

method ApptList time {y} {
    return [expr int((($y + 1) * 30) / $slot(font_height))]
}

method ApptList coordinate {time} {
    return [expr "($time * $slot(font_height)) / 30 - 1"]
}

method ApptList check_selection {args} {
    # Get newly selected item if it belongs to this window
    set newsel {}
    if ![string compare [ical_focus] [winfo toplevel $slot(window)]] {
        # This window is active, try to get the selected item
        catch {set newsel [ical_find_selection]}
    }

    if [string compare $newsel $slot(sel)] {
        # Selection has changed
        set slot(sel) $newsel
        $self layout
    }
}

method ApptList layout {} {
    $self sortitems

    # Move current appt to end of list so it appears at top
    if {$slot(sel) != ""} {
        set list $slot(items)
        if [lremove list $slot(sel)] {
            lappend list $slot(sel)
        }
        set slot(items) $list
    }

    # Compute offset for each child (15 minute units?)

    # offset(i) for slot i keeps track of the current horizontal
    # adjustment for slot i
    for {set i 0} {$i < 24*4} {incr i} {
        set offset($i) 0
    }

    foreach a $slot(items) {
        set start [expr [$a starttime $slot(date)]/15]
        set finish [expr ([$a starttime $slot(date)]+[$a length]-1)/15]
        if {$finish >= 24*4} {
            set finish [expr 24*4-1]
        }

        set adjust 0
        for {set i $start} {$i <= $finish} {incr i} {
            if {$adjust < $offset($i)} {
                set adjust $offset($i)
            }
        }
        for {set i $start} {$i <= $finish} {incr i} {
            set offset($i) [expr $adjust+1]
        }

        # Place the child
        set slot(adjust.$a) $adjust
        $self place $a

        if {$adjust > 0} {
            $slot(window.$a) raise
        }
    }
}

# effects - Sort item list
method ApptList sortitems {} {
    # Construct list of pairs <time,item>
    set list ""
    foreach item $slot(items) {
        lappend list [list [$item starttime $slot(date)] $item]
    }

    set items ""
    foreach pair [lsort $list] {
        lappend items [lindex $pair 1]
    }
    set slot(items) $items
}

# effects - Create window for item
method ApptList make_window {item} {
    set slot(adjust.$item) 0
    set slot(window.$item) [ApptItemWindow\
                                $slot(window).c\
                                $slot(font)\
                                $item $slot(date)\
                                [list $self move]\
                                [list $self resize]]
}

# effects - Place window for item
method ApptList place {a} {
    $self set_geometry $a [$a starttime $slot(date)] [$a length]
}

# effects - Set item window geometry from "start/length"
method ApptList set_geometry {a start length} {
    set adj [expr "$slot(adjust.$a) * $slot(font_height)"]
    set finish [expr $start + $length]

    set x [expr "$slot(label_width) + $adj + [pref itemPad]"]
    set y [expr "[$self coordinate $start]+1"]
    set width [expr "$slot(width)-$adj-2*[pref itemPad]"]
    set height [expr "[$self coordinate $finish] - $y"]

    $slot(window.$a) raise
    $slot(window.$a) geometry $x $y $width $height
}

# Callbacks

method ApptList canvas_resize {w h} {
    $slot(window).c coord bg 0 0 $w [expr 48 * $slot(font_height)]
}

method ApptList move {item y} {
    if {$y == "done"} {
        $item starttime $slot(date) $slot(itemstart)
        unset slot(itemstart)
        return
    }

    set st [expr "([$self time $y]/15)*15"]
    if {$st < 0} {set st 0}
    if {($st + [$item length]) > 24*60} {set st [expr 24*60-[$item length]]}

    set slot(itemstart) $st
    $self set_geometry $item $st [$item length]
}

method ApptList resize {item top bot} {
    if {$top == "done"} {
        # slot(itemstart) or slot(itemlength) may not have been set yet.
        if {[info exists slot(itemstart)] && [info exists slot(itemlength)]} {
            $item starttime $slot(date) $slot(itemstart)
            $item length $slot(itemlength)
        }

        catch {unset slot(itemstart)}
        catch {unset slot(itemlength)}

        return
    }

    set st [expr "([$self time $top]/15)*15"]
    if {$st < 0} {set st 0}

    set fi [expr "(([$self time $bot]+14)/15)*15"]
    if {$fi > 24*60} {set fi [expr 24*60]}

    set len [expr $fi - $st]
    if {$len >= 30} {
        set slot(itemstart) $st
        set slot(itemlength) $len
        $self set_geometry $item $st $len
    }
}
