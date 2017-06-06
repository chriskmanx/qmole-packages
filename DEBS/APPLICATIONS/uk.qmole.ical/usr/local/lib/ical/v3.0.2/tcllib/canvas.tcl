# Copyright (c) 1995 by Sanjay Ghemawat
#############################################################################
# Canvas editing operations

#### Make canvas bindings for specified tag ####

# XXX Still left to do XXX
#
# Clicking/double-clicking/triple-clicking
# Keyboard shortcuts for setting the selection
# Selection operations
# Emacs key bindings
# Control-t binding

proc tkCanvasBindings {tag} {
    bind $tag <KeyPress> {
        if [string compare %A {}] {
            tkCanvasMod %W tkCanvasInsert %W %A
        }
    }
        
    # This is to prevent matching against default keypress bindings, etc.
    bind $tag <Alt-KeyPress>            {continue}
    bind $tag <Control-KeyPress>        {continue}
    bind $tag <Meta-KeyPress>           {continue}
    
    bind $tag <Left> {
        tkCanvasMoveTo %W [expr [tkCanvasIndex %W] -1]
    }
    bind $tag <Right> {
        tkCanvasMoveTo %W [expr [tkCanvasIndex %W] +1]
    }
    bind $tag <Up> {
        tkCanvasMoveTo %W [tkCanvasMoveLine %W -1]
    }
    bind $tag <Down> {
        tkCanvasMoveTo %W [tkCanvasMoveLine %W +1]
    }
    bind $tag <Control-Left> {
        tkCanvasMoveTo %W [tkCanvasMoveWord %W -1]
    }
    bind $tag <Control-Right> {
        tkCanvasMoveTo %W [tkCanvasMoveWord %W +1]
    }
    bind $tag <Home> {
        tkCanvasMoveTo %W 0
    }
    bind $tag <End> {
        tkCanvasMoveTo %W end
    }
    bind $tag <Tab> {
        tkCanvasMod %W tkCanvasInsert %W \t
    }
    bind $tag <Control-i> {
        tkCanvasMod %W tkCanvasInsert %W \t
    }
    bind $tag <Return> {
        tkCanvasMod %W tkCanvasInsert %W \n
    }
    bind $tag <Delete> {
        tkCanvasMod %W tkCanvasDeleteCharBackward %W
    }
    bind $tag <BackSpace> {
        tkCanvasMod %W tkCanvasDeleteCharBackward %W
    }

    global tk_strictMotif
    if $tk_strictMotif return

    # Emacs-style keybindings
    bind $tag <Control-a> {
        tkCanvasMoveTo %W [tkCanvasBol %W]
    }
    bind $tag <Control-b> {
        tkCanvasMoveTo %W [expr [tkCanvasIndex %W] -1]
    }
    bind $tag <Control-d> {
        tkCanvasMod %W tkCanvasDeleteCharForward %W
    }
    bind $tag <Control-e> {
        tkCanvasMoveTo %W [tkCanvasEol %W]
    }
    bind $tag <Control-f> {
        tkCanvasMoveTo %W [expr [tkCanvasIndex %W] +1]
    }
    bind $tag <Control-k> {
        tkCanvasMod %W tkCanvasEmacsKillLine %W
    }
    bind $tag <Control-n> {
        tkCanvasMoveTo %W [tkCanvasMoveLine %W +1]
    }
    bind $tag <Control-o> {
        tkCanvasMod %W tkCanvasOpenLine %W
    }
    bind $tag <Control-p> {
        tkCanvasMoveTo %W [tkCanvasMoveLine %W -1]
    }
    bind $tag <Meta-b> {
        tkCanvasMoveTo %W [tkCanvasMoveWord %W -1]
    }
    bind $tag <Meta-d> {
        tkCanvasMod %W tkCanvasDeleteWordForward %W
    }
    bind $tag <Meta-f> {
        tkCanvasMoveTo %W [tkCanvasMoveWord %W +1]
    }
    bind $tag <Meta-less> {
        tkCanvasMoveTo %W 0
    }
    bind $tag <Meta-greater> {
        tkCanvasMoveTo %W end
    }
    bind $tag <Meta-BackSpace> {
        tkCanvasMod %W tkCanvasDeleteWordBackward %W
    }
    bind $tag <Meta-Delete> {
        tkCanvasMod %W tkCanvasDeleteWordBackward %W
    }
    bind $tag <Control-w> {
        tkCanvasMod %W tkCanvasCutRegion %W
    }
    bind $tag <Control-y> {
        tkCanvasMod %W tkCanvasPaste %W
    }
    bind $tag <Meta-w> {
        tkCanvasCopyRegion %W
    }
}

# Proc designed to be replaced in canvas bindings with a proc
# that checks for writability of the the canvas before executing
# its arguments.
proc tkCanvasMod {w args} {
    eval $args
}

proc tkCanvasMoveTo {w index} {
    $w icursor [$w focus] $index
}

proc tkCanvasIndex {w} {
    return [$w index [$w focus] insert]
}

proc tkCanvasMoveLine {w n} {
    set p [tkCanvasIndex $w]
    set v [$w itemcget [$w focus] -text]

    # Split into lines
    set lines [split $v "\n"]
    set num [llength $lines]

    # Find line/column for "p"
    set l 0
    set c $p
    foreach line $lines {
        set linelength [string length $line]
        if {$linelength >= $c} break
        incr l
        incr c [expr -$linelength -1]
    }

    # New line number
    incr l $n
    if {$l < 0} {return $p}
    if {$l >= $num} {return $p}
    set linelength [string length [lindex $lines $l]]
    if {$linelength < $c} {set c $linelength}

    set p $c
    for {set i 0} {$i < $l} {incr i} {
        incr p
        incr p [string length [lindex $lines $i]]
    }
    return $p
}

proc tkCanvasMoveWord {w n} {
    set p [tkCanvasIndex $w]
    set v [$w itemcget [$w focus] -text]
    while {$n > 0} {
        set p [string wordend $v $p]
        incr n -1
    }
    while {$n < 0} {
        set p [string wordstart $v [expr $p - 1]]
        incr n
    }
    return $p
}

proc tkCanvasBol {w} {
    set p [tkCanvasIndex $w]
    set v [$w itemcget [$w focus] -text]
    while {$p > 0} {
        if {[string index $v [expr $p-1]] == "\n"} break
        incr p -1
    }
    return $p
}

proc tkCanvasEol {w} {
    set p [tkCanvasIndex $w]
    set v [$w itemcget [$w focus] -text]
    set e [string length $v]

    while {$p < $e} {
        if {[string index $v $p] == "\n"} break
        incr p
    }
    return $p
}

proc tkCanvasInsert {w str} {
    $w insert [$w focus] insert $str
}

proc tkCanvasDeleteCharBackward {w} {
    set i [$w focus]
    if [catch {$w dchars $i sel.first sel.last}] {
        set index [$w index $i insert]
        if {$index > 0} {$w dchars $i [expr $index-1]}
    }
}

proc tkCanvasDeleteCharForward {w} {
    set i [$w focus]
    if [catch {$w dchars $i sel.first sel.last}] {
        $w dchars $i insert
    }
}

proc tkCanvasEmacsKillLine {w} {
    set p [tkCanvasIndex $w]
    set e [tkCanvasEol $w]
    if {$p == $e} {
        $w dchars [$w focus] $p $e
    } else {
        $w dchars [$w focus] $p [expr $e-1]
    }
}

proc tkCanvasDeleteWordBackward {w} {
    set p [tkCanvasIndex $w]
    set x [tkCanvasMoveWord $w -1]
    if {$x < $p} {
        $w dchars [$w focus] $x [expr $p-1]
    }
}

proc tkCanvasDeleteWordForward {w} {
    set p [tkCanvasIndex $w]
    set x [tkCanvasMoveWord $w +1]
    if {$x > $p} {
        $w dchars [$w focus] $p [expr $x-1]
    }
}

proc tkCanvasOpenLine {w} {
    tkCanvasInsert $w \n
    tkCanvasMoveTo $w [expr [tkCanvasIndex $w] -1]
}

proc tkCanvasCutRegion {w} {
    tkCanvasCopyRegion $w
    catch {$w dchars [$w focus] sel.first sel.last}
}

proc tkCanvasCopyRegion {w} {
    set v [$w itemcget [$w focus] -text]
    catch {
        set a [$w index [$w focus] sel.first]
        set b [$w index [$w focus] sel.last]
        clipboard clear -displayof $w
        clipboard append -displayof $w -- [string range $v $a $b]
    }
}

proc tkCanvasPaste {w} {
    if [catch {set sel [selection get -displayof $w]}] {
        catch {set sel [selection get -displayof $w -selection CLIPBOARD]}
    }

    if [info exists sel] {
        $w insert [$w focus] insert $sel
    }
}
