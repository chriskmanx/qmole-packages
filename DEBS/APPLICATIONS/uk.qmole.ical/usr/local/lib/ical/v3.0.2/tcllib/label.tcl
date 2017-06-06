# Copyright (c) 1994 by Sanjay Ghemawat
#############################################################################

# requires      $widget is packed in some master
# effects       Label $widget with $text
proc label_widget {widget text} {
    label $widget-label -text $text -anchor w -relief raised -borderwidth 1
    pack $widget-label -before $widget -side top -fill x
}

# requires      $w is packed in some master
# effects       Wrap a vertical scrollbar on the specified side of $w
proc attach_vscrollbar {w {side right}} {
    scrollbar $w-vscroll -orient vertical -command [list $w yview]
    $w configure -yscrollcommand [list $w-vscroll set]

    pack $w-vscroll -before $w -side $side -fill y
}

# effects       Make a scrollable single selection listbox named
#               $lbox in frame $frame.  Attach $label at the top
#               and a scrollbar on $side.
proc make_selection_list {frame lbox label {side right}} {
    frame $frame
    listbox $lbox -exportselection false -relief raised -borderwidth 1
    pack $lbox -in $frame -side top -expand 1 -fill both
    label_widget $lbox $label
    attach_vscrollbar $lbox $side
}
