# Copyright (c) 1994 by Sanjay Ghemawat
#############################################################################
# Dialog to get date range
#
# Commands
#
#       get_daterange <leader> <startvar> <finishvar>
#
#       Interact with user to get date range.  The initial values of
#       the variables named by <startvar> and <finishvar> are used to
#       initialize the range display.  When interaction is finished,
#       the selected range is stored in <startvar> and <finishvar>.
#       Returns true iff interaction is not cancelled by the user.

# Hidden global variables
#
#       dr_state(done)          Interaction has finished
#       dr_state(start)         Starting date
#       dr_state(finish)        Finishing date

set dr_state(done)              0
set dr_state(start)             {}
set dr_state(finish)            {}

proc get_daterange {leader svar fvar} {
    # Initialize state
    global dr_state
    upvar $svar start
    upvar $fvar finish
    set dr_state(start)  [date2text_no_weekday $start]
    set dr_state(finish) [date2text_no_weekday $finish]
    
    dr_init

    if ![dr_interact $leader] {return 0}

    if [catch {set start [date_parse $dr_state(start)]}] {return 0}
    if [catch {set finish [date_parse $dr_state(finish)]}] {return 0}
    return 1
}

proc dr_init {} {
    global dr_state
    set f .dr_dialog
    if [winfo exists $f] {return}

    toplevel $f -class Dialog
    wm title $f "Select Range"
    wm iconname $f "Range"
    wm protocol $f WM_DELETE_WINDOW {set dr_state(done) 0}

    frame $f.top -class Pane
    message $f.text -aspect 800 -text {Restrict item repetition range...}
    pack $f.text -in $f.top -side top -expand 1 -fill both -padx 5m -pady 5m

    frame $f.mid -class Pane
    entry $f.start -textvariable dr_state(start)
    entry $f.finish -textvariable dr_state(finish)
    label $f.to -text to
    pack $f.start   -in $f.mid -side top -expand 1 -fill both -padx 5m -pady 5m
    pack $f.to      -in $f.mid -side top -expand 1 -fill both
    pack $f.finish  -in $f.mid -side top -expand 1 -fill both -padx 5m -pady 5m

    make_buttons $f.bot 1 {
        {Cancel         {set dr_state(done) 0}}
        {Okay           {set dr_state(done) 1}}
    }

    pack $f.top -side top -fill both -expand 1
    pack $f.mid -side top -fill both -expand 1
    pack $f.bot -side bottom -fill x

    bind $f <Control-c> {set dr_state(done) 0}
    bind $f <Return>    {set dr_state(done) 1}

    wm withdraw $f
    update

    # Set-up a variable trace to track changes to editor state
    trace variable dr_state(start)  w dr_validate
    trace variable dr_state(finish) w dr_validate
    dr_validate
}

proc dr_interact {leader} {
    global dr_state
    set f .dr_dialog

    set dr_state(done) -1
    dialog_run $leader $f dr_state(done)
    return $dr_state(done)
}

proc dr_validate {args} {
    global dr_state
    if {[catch {date_parse $dr_state(start)}] ||
        [catch {date_parse $dr_state(finish)}]} {
        .dr_dialog.bot.b1 configure -state disabled
    } else {
        .dr_dialog.bot.b1 configure -state normal
    }
}
