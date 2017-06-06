# Copyright (c) 1993 by Sanjay Ghemawat
#############################################################################
# Yes/No Dialog
#
# Commands
#
#       yes_or_no <leader> <message> <yes-text>? <no-text>?
#               Confirm with user.

# Hidden global variables
#
#       yn_done                 Is yes_or_no interaction finished

set yn_done 0

proc yes_or_no {leader message {y Okay} {n Cancel}} {
    yn_make
    return [yn_interact $leader $message $y $n]
}

proc yn_make {} {
    set f .yn_dialog
    if [winfo exists $f] {return}

    toplevel $f -class Dialog
    wm title $f Confirm
    wm protocol $f WM_DELETE_WINDOW {set yn_done 0}

    frame $f.top -class Pane

    message $f.text -aspect 400 -text {Uninitialized message}
    make_buttons $f.bot 1 {
        {Cancel         {set yn_done 0}}
        {Okay           {set yn_done 1}}
    }

    pack $f.text -in $f.top -side right -expand 1 -fill both -padx 5m -pady 5m
    pack $f.top -side top -expand 1 -fill both
    pack $f.bot -side bottom -fill both

    bind $f <Control-c> {set yn_done 0}
    bind $f <Return> {set yn_done 1}

    wm withdraw $f
    update
}

proc yn_interact {leader message y n} {
    global yn_done
    set f .yn_dialog

    # Fix dialog contents
    $f.text configure -text $message
    $f.bot.b0 configure -text $n
    $f.bot.b1 configure -text $y

    # Run dialog
    set yn_done -1
    dialog_run $leader $f yn_done

    return $yn_done
}
