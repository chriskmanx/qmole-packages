# Copyright (c) 1994 by Sanjay Ghemawat
#############################################################################
# Key editing dialog
#
# Commands
#
#       define_key <leader> <var>
#
#       Interact with user to get a key definition.
#       Sets <var> to result when done.
#       The result is a list with two elements.  The first element
#       is a key sequence, and the second is a command name.

set defkey(done) -1
set defkey(help) 0
set defkey(cmd)  {}

proc define_key {leader var} {
    defkey_make

    set result [defkey_interact $leader]
    if $result {
        set key [keyentry_get .defkey.key]
        set val [.defkey.val get]

        upvar $var resultVar
        set resultVar [list $key $val]
    }
    return $result
}

proc defkey_make {} {
    global defkey
    set f .defkey
    if [winfo exists $f] {return}

    toplevel $f -class Dialog
    wm title $f "Define Key"
    wm protocol $f WM_DELETE_WINDOW {set defkey(done) 0}

    frame $f.top -class Pane
    frame $f.mid -class Pane

    make_buttons $f.bot 3 {
        {Clear                  {defkey_clear_key}}
        {Help                   {defkey_help_toggle}}
        {Cancel                 {set defkey(done) 0}}
        {Okay                   {set defkey(done) 1}}
    }

    message $f.text -aspect 400 -text [join {
        "Enter a key binding by clicking on the key field and"
        "typing the key binding.\n\n"
        "Select a command to be executed either by typing it"
        "into the command field, or by picking it from the list"
        "of displayed commands.\n\n"
        "You can delete an existing key binding by entering the key"
        "binding and leaving the command field blank."
    }]
    pack $f.text -in $f.top -side right -expand 1 -fill both -padx 5m -pady 5m

    # Create the various fields
    frame $f.kframe
    entry $f.key
    keyentry $f.key
    pack $f.key -in $f.kframe -side top -expand 1 -fill both
    label_widget $f.key {Key Sequence}
    $f.key-label configure -relief flat

    frame $f.vframe
    entry $f.val -textvariable defkey(cmd)
    pack $f.val -in $f.vframe -side top -expand 1 -fill both
    label_widget $f.val {Command}
    $f.val-label configure -relief flat

    label $f.cmdinfo -text "" -anchor w

    make_selection_list $f.lst $f.list Commands
    $f.key configure -width 20
    $f.val configure -width 20
    $f.lst configure -relief groove -borderwidth 2
    $f.list configure -width 30 -height 12

    pack $f.cmdinfo -in $f.mid -side bottom -fill x -padx 5m -pady 2m

    pack $f.lst -in $f.mid -side right -fill x -padx 5m -pady 5m -anchor e

    pack $f.kframe -in $f.mid -side top -fill x -padx 5m -pady 5m
    pack $f.vframe -in $f.mid -side bottom -fill x -padx 5m -pady 5m

    set defkey(help) 0

    pack $f.mid -side top -expand 1 -fill both
    pack $f.bot -side bottom -expand 1 -fill both

    bind $f.list <ButtonRelease-1> defkey_select_command
    trace variable defkey(cmd) w {defkey_changed_command}

    wm withdraw $f
    update
}

proc defkey_interact {leader} {
    global defkey action_title
    set f .defkey

    keyentry_set $f.key ""
    $f.val delete 0 end

    # Enter command entries
    $f.list delete 0 end
    foreach name [lsort [array names action_title]] {
        $f.list insert end $name
    }

    # Start off without help message
    if $defkey(help) {defkey_help_toggle}

    # Run dialog
    set defkey(done) -1
    dialog_run $leader $f defkey(done)

    return $defkey(done)
}

proc defkey_select_command {} {
    global defkey
    set f .defkey

    set sel [$f.list curselection]
    if {[llength $sel] != 1} return
    $f.val delete 0 end
    $f.val insert insert [$f.list get [lindex $sel 0]]
}

proc defkey_changed_command {args} {
    global defkey action_title
    set f .defkey

    if [info exists action_title($defkey(cmd))] {
        $f.cmdinfo configure -text $action_title($defkey(cmd))
    } else {
        $f.cmdinfo configure -text ""
    }
}

proc defkey_clear_key {} {
    set f .defkey
    keyentry_set $f.key {}
}

proc defkey_help_toggle {} {
    global defkey

    set f .defkey
    if $defkey(help) {
        pack forget $f.top
        set defkey(help) 0
    } else {
        pack $f.top -before $f.mid -side top -expand 1 -fill both       
        set defkey(help) 1
    }
}
