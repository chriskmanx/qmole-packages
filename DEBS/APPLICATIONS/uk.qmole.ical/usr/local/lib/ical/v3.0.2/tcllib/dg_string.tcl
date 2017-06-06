# Copyright (c) 1993 by Sanjay Ghemawat
#############################################################################
# String Dialog
#
# Commands
#
#       get_string <leader> <title> <message> <init> <var>
#               Get string from user.  The string is stored in <var>.
#               Returns true iff user does not cancel operation.

# Hidden global variables
#
#       str_done                Is str interaction finished
#       str_value               String value

set str_done 0
set str_value {}

proc get_string {leader title message init var} {
    str_make

    global str_value
    set str_value $init
    set result [str_interact $leader $title $message]
    if $result {
        upvar $var returnVar
        set returnVar $str_value
    }
    return $result
}

proc str_make {} {
    set f .string_dialog
    if [winfo exists $f] {return}

    toplevel $f -class Dialog
    wm title $f Dialog
    wm protocol $f WM_DELETE_WINDOW {set str_done 0}

    frame $f.top -class Pane
    frame $f.mid -class Pane

    message $f.text -aspect 400 -text {Uninitialized message}
    entry $f.entry -textvariable str_value -width 30
    make_buttons $f.bot 1 {
        {Cancel         {set str_done 0}}
        {Okay           {set str_done 1}}
    }

    pack $f.text -in $f.top -side top -expand 1 -fill both -padx 5m -pady 5m
    pack $f.entry -in $f.mid -side top -expand 1 -padx 5m -pady 5m -fill x

    pack $f.top -side top -expand 1 -fill both
    pack $f.mid -side top -fill x
    pack $f.bot -side bottom -fill x

    bind $f <Control-c> {set str_done 0}
    bind $f <Return> {set str_done 1}

    wm deiconify $f
    update
}

proc str_interact {leader title message} {
    global str_done
    set f .string_dialog

    # Fix dialog contents
    $f.text configure -text $message
    wm title $f $title

    # Run dialog
    set str_done -1
    dialog_run $leader $f str_done $f.entry

    return $str_done
}
