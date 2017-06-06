# Copyright?
#
# This file was copied from the Tk demo directory and modified by
# Sanjay Ghemawat for use as a generic dialog element for selecting
# a set of integers from a specific range.

# Usage: ruler <w> <label> <min> <max> <major> <minor> <unit>
#
# Create a ruler from <min> to <max> with major and minor hash marks.
# The new window is called <w>.  Minor hash marks are <unit> apart.
#
# Example: The following command creates a scale from 0 to 60 with
# major hash marks on every multiple of 5, and minor hash marks on
# every multiple of 1.  Minor hash marks are separated by 2mm.
#
#       ruler .c {Select positions} 0 60 5 1 2m

proc ruler {c label min max major minor unit} {
    upvar #0 ruler_$c v
    catch {destroy $c}

    canvas $c

    # Get layout info
    set v(min)    $min
    set v(max)    $max
    set v(minor)  $minor
    set v(major)  $major
    set v(unit)   [winfo pixels . $unit]

    set v(left)   [winfo pixels $c 1c]
    set v(right)  [expr $v(left) + (($max - $min) * $v(unit))/$minor]
    set v(top)    [winfo pixels $c 2c]
    set v(bottom) [winfo pixels $c 2.5c]
    set v(size)   [winfo pixels $c 2m]

    $c configure -width [expr $v(right) + [winfo pixels $c 2c]] -height 3.5c

    # Get normal/active colors
    set nfg [option get $c apptLineColor Foreground]
    if ![string compare $nfg ""] {set nfg black}

    set afg $nfg
    if [string match *color* [winfo screenvisual .]] {set afg red}

    set v(normalStyle) "-fill $nfg"
    set v(activeStyle) "-fill $afg -stipple {}"
    set v(deleteStyle) "-stipple gray25 -fill $afg"

    # Find font
    set textoptions [list -fill $nfg]
    set o [option get $c itemFont Font]
    if [string compare $o ""] {
        lappend textoptions -font $o
    }

    # Create label
    eval $c create text $v(left) 3c -tags {label} -anchor sw
    $c itemconfigure label -text $label
    eval $c itemconfigure label $textoptions

    # Create horizontal line
    $c create line $v(left) 2c $v(right) 2c -fill $nfg

    set x $v(left)
    set off 0
    for {set i $min} {$i <= $max} {incr i $minor} {
        if {($off % $major) == 0} {
            # Major hash mark
            $c create line $x 2c $x 1.5c -fill $nfg
            eval $c create text $x 1.4c -text $i -anchor s $textoptions
        } else {
            # Minor hash mark
            $c create line $x 2c $x 1.75c -fill $nfg
        }

        incr off $minor
        incr x $v(unit)
    }

    set wl [expr $v(right) + [winfo pixels $c .2c]]
    set wc [expr $v(right) + [winfo pixels $c .6c]]
    set wr [expr $v(right) + [winfo pixels $c 1c]]

    $c addtag well withtag [$c create rect $wl 2c $wr 1.5c\
                            -outline $nfg -fill [lindex [$c config -bg] 4]]
    $c addtag well withtag [ruler_tab $c $wc [winfo pixels $c 1.65c]]

    foreach d {1 2 3} {
        $c bind well <$d>               [list ruler_newtab $c %x %y]
        $c bind tab <$d>                [list ruler_select $c %x %y]
        bind $c <B$d-Motion>            [list ruler_move $c %x %y]
        bind $c <ButtonRelease-$d>      [list ruler_release $c]
    }
}

# effects  Modify the label for the ruler
proc ruler_setlabel {c label} {
    $c itemconfigure label -text $label
}

# effects  Remove all existing tabs and create tabs at specified positions.
proc ruler_settabs {c pos} {
    upvar #0 ruler_$c v

    $c delete tab

    set y [expr $v(top)+2]
    foreach p $pos {
        set x [ruler_canvas_coord $c $p]
        $c addtag tab withtag [ruler_tab $c $x $y]
    }
}

# effects  Return list of positions of current tabs.
proc ruler_tabs {c} {
    upvar #0 ruler_$c v

    set result {}
    foreach i [$c find withtag tab] {
        set coords [$c coords $i]
        if {[llength $coords] < 6} continue
        set x [lindex $coords 0]
        lappend result [ruler_user_coord $c $x]
    }
    return [lsort -integer $result]
}

# effects  Return user-coordinate value for specified canvas position
proc ruler_user_coord {c x} {
    upvar #0 ruler_$c v
    return [expr round((($x-$v(left))*$v(minor))/$v(unit)+$v(min))]
}

# effects  Return canvas-coordinate value for specified user position
proc ruler_canvas_coord {c x} {
    upvar #0 ruler_$c v
    return [expr ((($x*1.0 - $v(min)) * $v(unit)) / $v(minor)) + $v(left)]
}

# effects  Create a tab at "x,y"
proc ruler_tab {c x y} {
    upvar #0 ruler_$c v
    return [eval $c create polygon $x $y [expr $x+$v(size)] [expr $y+$v(size)]\
            [expr $x-$v(size)] [expr $y+$v(size)] $v(normalStyle)]
}

proc ruler_newtab {c x y} {
    upvar #0 ruler_$c v
    $c addtag active withtag [ruler_tab $c $x $y]
    $c addtag tab withtag active
    ruler_move $c $x $y
}

proc ruler_move {c x y} {
    upvar #0 ruler_$c v
    if {[$c find withtag active] == ""} {return}

    set cx [$c canvasx $x $v(unit)]
    set cy [$c canvasy $y]
    if {$cx < $v(left)} {set cx $v(left)}
    if {$cx > $v(right)} {set cx $v(right)}

    # Is tab in active region?
    if {($cy >= $v(top)) && ($cy <= $v(bottom))} {
        set cy [expr $v(top)+2]
        eval "$c itemconf active $v(activeStyle)"
    } else {
        set cy [expr $cy-$v(size)-2]
        eval "$c itemconf active $v(deleteStyle)"
    }

    # Translate X coordinate to grid
    set cx [ruler_canvas_coord $c [ruler_user_coord $c $cx]]

    # Move the item
    set coords [$c coords active]
    if {[llength $coords] < 6} return
    set v_x [lindex $coords 0]
    set v_y [lindex $coords 1]
    $c move active [expr $cx-$v_x] [expr $cy-$v_y]
}

proc ruler_select {c x y} {
    upvar #0 ruler_$c v

    $c addtag active withtag current
    eval "$c itemconf active $v(activeStyle)"
    $c raise active
}

proc ruler_release c {
    upvar #0 ruler_$c v
    if {[$c find withtag active] == {}} {
        return
    }

    set coords [$c coords active]
    if {[llength $coords] < 6} return
    set v_y [lindex $coords 1]

    if {($v_y < [expr $v(top)+1]) || ($v_y > [expr $v(top)+3])} {
        $c delete active
    } else {
        eval "$c itemconf active $v(normalStyle)"
        $c dtag active
    }
}
