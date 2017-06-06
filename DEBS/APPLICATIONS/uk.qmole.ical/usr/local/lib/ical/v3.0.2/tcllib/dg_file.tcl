# Copyright (c) 1993 by Sanjay Ghemawat
#############################################################################
# File Dialog
#
# Commands
#
#       get_file_name <leader> <title> <message> <var> [<init>]
#               Get file name from user.  The name is stored in <var>.
#               Returns true iff user does not cancel operation.

# Hidden global variables
#
#       file_done               Is file interaction finished

set file_done 0

proc get_file_name {leader title message var {init {}}} {
    file_make

    set result [file_interact $leader $title $message $init]
    if $result {
        upvar $var returnVar
        set returnVar [fs_filename .file_dialog.box]
    }
    return $result
}

proc file_make {} {
    global file_done
    set f .file_dialog
    if [winfo exists $f] return

    toplevel $f -class Dialog
    wm title $f Dialog
    wm protocol $f WM_DELETE_WINDOW {set file_done 0}

    frame $f.top -class Pane
    frame $f.mid -class Pane

    FileSelector $f.box
    message $f.text -aspect 400 -text {Uninitialized message}
    make_buttons $f.bot 1 {
        {Cancel         {set file_done 0}}
        {Okay           {set file_done 1}}
    }

    pack $f.text -in $f.top -side top -expand 1 -fill both -padx 5m -pady 5m
    pack $f.box -in $f.mid -side top -expand 1 -padx 5m -pady 5m

    pack $f.top -side top -expand 1 -fill both
    pack $f.mid -side top -expand 1 -fill both
    pack $f.bot -side top -expand 1 -fill both

    bind $f <Control-c> {set file_done 0}
    bind $f <Return> {set file_done 1}
    bind $f.box.children <Double-Button-1> {file_done_check}

    wm withdraw $f
    update
}

proc file_interact {leader title message init} {
    global file_done
    set f .file_dialog

    # Fix dialog contents
    $f.text configure -text $message
    wm title $f $title
    if [string compare $init {}] {
        fs_goto $f.box $init
    }

    # Run dialog
    set file_done -1
    dialog_run $leader $f file_done $f.box.entry

    return $file_done
}

proc file_done_check {} {
    global file_done

    if ![file isdirectory [fs_filename .file_dialog.box]] {
        set file_done 1
    }
}
