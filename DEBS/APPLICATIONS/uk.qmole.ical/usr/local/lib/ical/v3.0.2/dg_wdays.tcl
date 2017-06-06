# Copyright (c) 1993 by Sanjay Ghemawat
#############################################################################
# Set of weekdays dialog
#
# Commands
#
#       weekrepeat <leader> <item> <anchor>
#
#       Interact with user to determine weekly repetition of item.
#       Returns true iff item is modified.

# Hidden global variables
#
#       ws_state(done)          Is ws interaction finished
#       ws_state(1..7)          Set iff specified weekday was selected
#       ws_state(int)           Week interval

set ws_state(done) 0
foreach i {1 2 3 4 5 6 7} {
    set ws_state($i) 0
}

proc weekrepeat {leader item anchor} {
    ws_make

    if ![ws_interact $leader $item $anchor] {return 0}

    global ws_state
    if {$ws_state(int) == 1} {
        set list {}
        foreach i {1 2 3 4 5 6 7} {
            if $ws_state($i) {lappend list $i}
        }

        if {[llength $list] == 0} {
            if ![yes_or_no $leader {Should item be completely deleted?}] {
                return 0
            }
        }

        eval [list $item weekdays] $list
        $item start $anchor
    } else {
        $item dayrepeat [expr $ws_state(int)*7] $anchor
        $item start $anchor
    }
    return 1
}

proc ws_make {} {
    set f .ws_dialog
    if [winfo exists $f] {return}

    toplevel $f -class Dialog
    wm title $f {Weekly Repetition}
    wm iconname $f Repeat
    wm protocol $f WM_DELETE_WINDOW {set ws_state(done) 0}

    frame $f.top   -class Pane
    frame $f.left  -class Pane
    frame $f.right -class Pane

    message $f.text -aspect 400 -text {Weekly Repetition...}
    pack $f.text -in $f.top -side top -expand 1 -fill both -padx 5m -pady 5m

    make_buttons $f.bot 1 {
        {Cancel         {set ws_state(done) 0}}
        {Okay           {set ws_state(done) 1}}
    }

    # Make set of weekdays
    global weekday_name
    set list {1 2 3 4 5 6 7}
    if [cal option MondayFirst] {set list {2 3 4 5 6 7 1}}
    foreach i $list {
        checkbutton $f.w$i\
            -anchor w\
            -padx 5m\
            -relief flat\
            -variable ws_state($i)\
            -text $weekday_name($i)
        pack $f.w$i -in $f.left -side top -fill x
    }

    # Make interval list
    set buttons {
        {{Weekly}               1}
        {{Every Two Weeks}      2}
        {{Every Three Weeks}    3}
        {{Every Four Weeks}     4}
    }

    foreach i $buttons {
        radiobutton $f.i[lindex $i 1]\
            -text [lindex $i 0]\
            -variable ws_state(int)\
            -value [lindex $i 1]\
            -padx 5m\
            -anchor w\
            -relief flat\
            -command {ws_reconfig}
        pack $f.i[lindex $i 1] -in $f.right -side top -fill x
    }

    pack $f.top -side top -fill x
    pack $f.bot -side bottom -fill x
    pack $f.right -side left -expand 1 -fill both
    pack $f.left -side left -expand 1 -fill both

    bind $f <Control-c> {set ws_state(done) 0}
    bind $f <Return>    {set ws_state(done) 1}

    wm withdraw $f
    update
}

proc ws_reconfig {} {
    global ws_state
    set state disabled
    if {$ws_state(int) == 1} {set state normal}
    foreach w {1 2 3 4 5 6 7} {
        .ws_dialog.w$w configure -state $state
    }
}

proc ws_interact {leader item anchor} {
    global ws_state
    set f .ws_dialog

    # Set initial selection from set of weekdays
    foreach i {1 2 3 4 5 6 7} {set ws_state($i) 0}
    set ws_state([date weekday $anchor]) 1

    set ws_state(int) 1
    ws_reconfig

    # Run dialog
    set ws_state(done) -1
    dialog_run $leader $f ws_state(done)

    # Construct return value
    return $ws_state(done)
}
