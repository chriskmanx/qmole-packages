# Copyright (c) 1994 by Sanjay Ghemawat
#############################################################################
# Dialog to set monthly repetition for an item.
#
# Commands
#
#       monthrepeat <leader> <item> <anchor date>
#
#       Interact with user to set monthly repetition for item.
#       Returns true iff <item> is modified.

# Hidden global variables
#
#       mr_state(done)          Interaction has finished
#       mr_state(item)          The item being modified
#       mr_state(int)           Repetition interval in months
#       mr_state(occ)           Type of monthly occurrence
#       mr_state(count:...)     Count for a particular type of occurrence

set mr_state(done)      0
set mr_state(item)      {}
set mr_state(occ)       {}
set mr_state(int)       {}

proc monthrepeat {leader item anchor} {
    monthrepeat_init
    if ![monthrepeat_interact $leader $item $anchor] {return 0}

    # Modify item appropriately
    global mr_state
    set c $mr_state(count:$mr_state(occ))
    switch $mr_state(occ) {
        month_week_day -
        month_last_week_day {
            set wday [date weekday $anchor]
            $item $mr_state(occ) $wday $c $anchor $mr_state(int)
            $item start $anchor
        }
        default {
            $item $mr_state(occ) $c $anchor $mr_state(int)
            $item start $anchor
        }
    }
    return 1
}

proc monthrepeat_init {} {
    set f .mr_dialog
    if [winfo exists $f] {return}

    toplevel $f -class Dialog
    wm title $f "Monthly Repetition"
    wm iconname $f "Repeat"
    wm protocol $f WM_DELETE_WINDOW {set mr_state(done) 0}

    frame $f.top   -class Pane
    frame $f.left  -class Pane
    frame $f.right -class Pane

    message $f.text -aspect 400 -text {Monthly Repetition...}
    pack $f.text -in $f.top -side top -expand 1 -fill both -padx 5m -pady 5m

    make_buttons $f.bot 1 {
        {Cancel         {set mr_state(done) 0}}
        {Okay           {set mr_state(done) 1}}
    }

    # Create interval buttons
    set buttons {
        {{Monthly}              1}
        {{Annual}               12}
        {{Every Two Months}     2}
        {{Every Three Months}   3}
        {{Every Four Months}    4}
        {{Every Six Months}     6}
    }

    foreach i $buttons {
        radiobutton $f.i[lindex $i 1] -text [lindex $i 0]\
            -variable mr_state(int) -value [lindex $i 1]\
            -padx 5m -anchor w -relief flat
        pack $f.i[lindex $i 1] -in $f.right -side top -fill x
    }

    # Create month occurrence buttons
    set buttons {
        {month_day}
        {month_last_day}
        {month_work_day}
        {month_last_work_day}
        {month_week_day}
        {month_last_week_day}
    }

    foreach i $buttons {
        radiobutton $f.$i -text $i\
            -variable mr_state(occ) -value $i\
            -padx 5m -anchor w -relief flat
        pack $f.$i -in $f.left -side top -fill x
    }

    pack $f.top -side top -fill x
    pack $f.bot -side bottom -fill x
    pack $f.left  -side left -expand 1 -fill both
    pack $f.right -side left -expand 1 -fill both

    bind $f <Control-c> {set mr_state(done) 0}
    bind $f <Return>    {set mr_state(done) 1}

    wm withdraw $f
    update
}

proc monthrepeat_interact {leader item anchor} {
    global mr_state
    set f .mr_dialog
    set mr_state(done) -1
    set mr_state(int)  1
    set mr_state(occ)  month_day

    set mday  [date monthday  $anchor]
    set msize [date monthsize $anchor]
    set wday  [date weekday   $anchor]
    set start [expr $anchor - ($mday - 1)]
    set last  [expr $anchor + ($msize - $mday)]

    global weekday_name
    set wday_name $weekday_name($wday)

    set mr_state(count:month_day) $mday
    $f.month_day configure -text "[num2text $mday] Day"

    set c [expr $msize - $mday + 1]
    set mr_state(count:month_last_day) $c
    if {$c == 1} {
        $f.month_last_day configure -text "Last Day"
    } else {
        $f.month_last_day configure -text "[num2text $c]-last Day"
    }

    if {($wday == 1) || ($wday == 7)} {
        # Weekend
        $f.month_work_day configure -state disabled
        $f.month_last_work_day configure -state disabled
    } else {
        $f.month_work_day configure -state normal
        $f.month_last_work_day configure -state normal
    }

    # Count number of working days in month on or before anchor
    set c 0
    for {set i $start} {$i <= $anchor} {incr i} {
        set w [date weekday $i]
        if {($w != 1) && ($w != 7)} {incr c}
    }
    if {$c < 1} {set c 1}
    set mr_state(count:month_work_day) $c
    $f.month_work_day configure -text "[num2text $c] Working Day"

    # Count number of working days in month on or after anchor
    set c 0
    for {set i $last} {$i >= $anchor} {incr i -1} {
        set w [date weekday $i]
        if {($w != 1) && ($w != 7)} {incr c}
    }
    if {$c < 1} {set c 1}
    set mr_state(count:month_last_work_day) $c
    if {$c == 1} {
        $f.month_last_work_day configure -text\
            "Last Working Day"
    } else {
        $f.month_last_work_day configure -text\
            "[num2text $c]-last Working Day"
    }

    # Count occurrences of week day
    set c [expr ($mday-1)/7 + 1]
    set mr_state(count:month_week_day) $c
    $f.month_week_day configure -text "[num2text $c] $wday_name"

    set c [expr ($msize-$mday)/7 + 1]
    set mr_state(count:month_last_week_day) $c
    if {$c == 1} {
        $f.month_last_week_day configure -text "Last $wday_name"
    } else {
        $f.month_last_week_day configure -text "[num2text $c]-last $wday_name"
    }

    dialog_run $leader $f mr_state(done)
    return $mr_state(done)
}
