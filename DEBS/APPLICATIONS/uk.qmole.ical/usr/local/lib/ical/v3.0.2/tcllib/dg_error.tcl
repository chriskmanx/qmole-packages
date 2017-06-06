# Copyright (c) 1993 by Sanjay Ghemawat
#############################################################################
# Error Dialog
#
# Commands
#
#       error_notify <leader> <message> [<title>]
#               Display error message to user.

# Hidden global variables
#
#       error_done              Is error interaction finished

set error_done 0

proc error_notify {leader message {title Error}} {
    if ![string compare [info commands tk] ""] {
        # Tk is not available
        puts stderr $message
        return
    }

    error_make
    error_interact $leader $message $title
}

proc error_make {} {
    set f .error_dialog
    if [winfo exists $f] {return}

    toplevel $f -class Dialog
    wm title $f Error
    wm protocol $f WM_DELETE_WINDOW {set error_done 1}

    frame $f.top -class Pane

    label $f.icon -bitmap warning
    message $f.text -aspect 400 -text {Uninitialized Error Message}
    make_buttons $f.bot 0 {
        {Okay {set error_done 1}}
    }

    pack $f.text -in $f.top -side right -expand 1 -fill both -padx 5m -pady 5m
    pack $f.icon -in $f.top -side left -padx 5m -pady 5m

    pack $f.top -side top -fill both
    pack $f.bot -side bottom -fill both

    bind $f <Control-c> {set error_done 1}
    bind $f <Return>    {set error_done 1}

    wm withdraw $f
    update
}

proc error_interact {leader message title} {
    global error_done
    set f .error_dialog

    # Fix dialog contents
    wm title $f $title
    $f.text configure -text $message

    # Run dialog
    set error_done -1
    dialog_run $leader $f error_done
}
