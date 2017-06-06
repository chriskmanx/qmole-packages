# Copyright (c) 1993 by Sanjay Ghemawat
#############################################################################
# Number Dialog
#
# Commands
#
# get_number <leader> <title> <label> <doc> <min> <max> <tick> <init> <var>
#               Get a number in the range <min>..<max> rounded to the
#               nearest <tick>.  The initial displayed value is <init>.
#               <title>/<label>/<doc> are used to prompt the user.  If the
#               user confirms the selection, set <var> to the selected number
#               and return true.  Else return false.

# Hidden global variables
#
#       num_done                Is num interaction finished

set num_done 0

proc get_number {leader title label doc min max tick init var} {
    num_make

    set result [num_interact $leader $title $label $doc $min $max $tick $init]
    if $result {
        upvar $var returnVar
        set returnVar [.number_dialog.scale get]
    }
    return $result
}

proc num_make {} {
    set f .number_dialog
    if [winfo exists $f] {return}

    toplevel $f -class Dialog
    wm title $f Dialog
    wm protocol $f WM_DELETE_WINDOW {set num_done 0}

    frame $f.top -class Pane
    frame $f.mid -class Pane

    message $f.doc -aspect 400 -text {Uninitialized message}
    pack $f.doc -in $f.top -side top -expand 1 -fill both

    scale $f.scale -orient horizontal -length 3i -showvalue 1
    make_buttons $f.bot 1 {
        {Cancel         {set num_done 0}}
        {Okay           {set num_done 1}}
    }

    pack $f.scale -in $f.mid -side top -expand 1 -padx 5m -pady 5m
    pack $f.top -side top -expand 1 -fill both
    pack $f.mid -side top -expand 1 -fill both
    pack $f.bot -side bottom -fill both

    bind $f <Control-c> {set num_done 0}
    bind $f <Return>    {set num_done 1}

    wm withdraw $f
    update
}

proc num_interact {leader title label doc min max tick init} {
    global num_done
    set f .number_dialog

    # Fix dialog contents
    $f.doc configure -text $doc
    $f.scale configure -from $min -to $max -tickinterval $tick -label $label
    $f.scale set $init
    wm title $f $title

    # Run dialog
    set num_done -1
    dialog_run $leader $f num_done

    return $num_done
}
