# Copyright (c) 1993 by Sanjay Ghemawat
#############################################################################
# Set of alarms dialog
#
# Commands
#
#       alarm_set <leader> <label> <resultvar> <initial alarm list>
#
#       Interact with user to determine set of alarm times.
#       The result is a list of elements ranging over 0..60 and is
#       stored in resultvar.  Returns true iff dialog is not cancelled.

# Hidden global variables
#
#       as_done                 Is as interaction finished
#       as_ruler                Ruler window name
#       as_helping              True iff help is being displayed

set as_done 0
set as_ruler ""
set as_helping 0

proc alarm_set {leader label var init} {
    as_make

    set result [as_interact $leader $label $init]
    if $result {
        global as_ruler
        upvar $var returnVar

        set returnVar [ruler_tabs $as_ruler]
    }
    return $result
}

proc as_make {} {
    set f .as_dialog
    if [winfo exists $f] {return}

    toplevel $f -class Dialog
    wm title $f "Set Alarm Times"
    wm protocol $f WM_DELETE_WINDOW {set as_done 0}

    frame $f.top -class Pane
    frame $f.mid -class Pane

    make_buttons $f.bot 2 {
        {Cancel                 {set as_done 0}}
        {Help                   {as_help_toggle}}
        {Okay                   {set as_done 1}}
    }

    message $f.text -aspect 400 -text [join {
        {Select set of alarm times in minutes.}
        {Create an alarm by dragging a marker out of the well at the}
        {right of the scale.}
        {You can also drag existing markers to change alarm times.}
        {If you drag a marker far enough up or down so that it turns}
        {dim, it will be deleted when you release the mouse button.}
    }]
    pack $f.text -in $f.top -side right -expand 1 -fill both -padx 5m -pady 5m

    global as_ruler
    set as_ruler $f.mid.ruler
    ruler $as_ruler {Alarms (in minutes)} 0 60 5 1 2m
    pack $as_ruler -in $f.mid -side top -expand 1 -fill both -padx 5m -pady 5m

    set as_helping 0
    #pack $f.top -side top -expand 1 -fill both

    pack $f.mid -side top -expand 1 -fill both
    pack $f.bot -side bottom -expand 1 -fill both

    bind $f <Control-c> {set as_done 0}
    bind $f <Return> {set as_done 1}

    wm withdraw $f
    update
}

proc as_interact {leader label init} {
    global as_ruler as_done
    set f .as_dialog

    # Initialize dialog
    ruler_setlabel $as_ruler $label
    ruler_settabs $as_ruler $init

    # Start off without help message
    global as_helping
    if $as_helping {
        as_help_toggle
    }

    # Run dialog
    set as_done -1
    dialog_run $leader $f as_done

    return $as_done
}

proc as_help_toggle {} {
    global as_helping

    set f .as_dialog
    if $as_helping {
        pack forget $f.top
        set as_helping 0
    } else {
        pack $f.top -before $f.mid -side top -expand 1 -fill both       
        set as_helping 1
    }
}
