# Copyright (c) 1996  by Sanjay Ghemawat
# Indicate time of day in appointment view

append-hook dayview-startup {view} {
    set c [$view window].al.c
    $c create line -1 -1 -1 -1 -arrow last\
        -arrowshape {2m 4m 2m}\
        -fill [pref apptLineColor] -tags {tod}

    position_tod [$view appt_list] $c
}

# Position the time-of-day indicator in the specified canvas "c".
# Also set up a call back to this procedure at the next minute boundary.
proc position_tod {al c} {
    if ![winfo exists $c] {return}

    set t [ical_time split [ical_time now]]
    set m [expr [lindex $t 0]*60 + [lindex $t 1]]

    set y [expr ($m * [$al line_height]) / 30]
    $c coords tod 2m $y 4m $y

    # Schedule next firing (at minute boundary)
    set msec [expr (60 - [ical_time second [ical_time now]])*1000]
    after $msec position_tod $al $c
}
