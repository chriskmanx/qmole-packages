# Copyright (c) 1993 by Sanjay Ghemawat
#############################################################################
# Yes/No/Cancel Dialog
#
# Commands
#
#       yes_no_cancel <leader> <message> <yes-text>? <no-text>? <cancel-text>?
#               Confirm with user.

# Hidden global variables
#
#       ync_done                State of yes_no_cancel interaction

set ync_done active

proc yes_no_cancel {leader message {y Yes} {n No} {c Cancel}} {
    ync_make
    return [ync_interact $leader $message $y $n $c]
}

proc ync_make {} {
    set f .ync_dialog
    if [winfo exists $f] {return}

    toplevel $f -class Dialog
    wm title $f Confirm
    wm protocol $f WM_DELETE_WINDOW {set ync_done cancel}

    frame $f.top -class Pane

    message $f.text -aspect 400 -text {Uninitialized message}
    make_buttons $f.bot 2 {
        {Cancel         {set ync_done cancel}}
        {No             {set ync_done no}}
        {Yes            {set ync_done yes}}
    }

    pack $f.text -in $f.top -side right -expand 1 -fill both -padx 5m -pady 5m

    pack $f.top -side top -expand 1 -fill both
    pack $f.bot -side bottom -fill both

    bind $f <Return>    {set ync_done yes}
    bind $f <n>         {set ync_done no}
    bind $f <Control-c> {set ync_done cancel}

    wm withdraw $f
    update
}

proc ync_interact {leader message y n c} {
    global ync_done
    set f .ync_dialog

    # Fix dialog contents
    $f.text configure -text $message
    $f.bot.b0 configure -text $c
    $f.bot.b1 configure -text $n
    $f.bot.b2 configure -text $y

    # Run dialog
    set ync_done active
    dialog_run $leader $f ync_done

    return $ync_done
}
