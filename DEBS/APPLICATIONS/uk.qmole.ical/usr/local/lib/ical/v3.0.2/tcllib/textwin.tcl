# Copyright (c) 1994 by Sanjay Ghemawat
#############################################################################

# effects       Create scrollable text widget named "$w"
#               The widget contains a text widget named "$w.text",
#               and a scrollbar named "$w.scroll"
proc make_scrolled_text {w} {
    frame $w
    scrollbar $w.scroll -orient vertical -command [list $w.text yview]
    text $w.text -relief raised -borderwidth 1\
        -yscrollcommand [list $w.scroll set]
    
    pack $w.scroll -side right -fill y
    pack $w.text -side left -expand 1 -fill both
}

set viewer_id 0

# effects  Create text viewer and return its window name.
#          The underlying text widget has name "<toplevel>.text"
proc make_text_viewer {title iconname} {
    global viewer_id
    incr viewer_id
    set f .textview$viewer_id

    set t "$f.text"
    set s "$f.scroll"

    toplevel $f -class Viewer
    wm iconname $f $iconname
    wm title $f $title

    # Move button to extreme right hand side.
    # XXX This depends on the internals of "make_buttons".
    make_buttons $f.bot 0 [list [list {Okay} [list destroy $f]]]
    pack $f.bot.def0 -side right -expand 0

    scrollbar $s -orient vertical -command [list $t yview]
    text $t -setgrid 1 -yscroll "$s set" -height 25 -width 80
    $t config -state disabled

    pack $f.bot -side bottom -fill x
    pack $s -side right -fill y
    pack $t -side left -expand 1 -fill both

    bind $f <Tab>               {break}
    bind $f <Control-c>         {destroy %W}
    bind $f <space>             {tkTextScrollPages %W.text 1}
    bind $f <Control-f>         {tkTextScrollPages %W.text 1}
    bind $f <Control-v>         {tkTextScrollPages %W.text 1}
    bind $f <Control-b>         {tkTextScrollPages %W.text -1}
    bind $f <Meta-v>            {tkTextScrollPages %W.text -1}
    bind $f <Delete>            {tkTextScrollPages %W.text -1}
    bind $f <BackSpace>         {tkTextScrollPages %W.text -1}

    return $f
}
