# Copyright (c) 1994 by Sanjay Ghemawat

# Parse string as an item and return it.
# If default_date is not supplied, it defaults to "[date today]"

proc item_parse {text {default_date ""}} {
    set type notice
    set date $default_date
    if ![string compare $date ""] {set date [date today]}

    if [date extract $text d j1 j2] {
        set date $d
    }

    if [ical_time extract_range $text start finish j1 j2] {
        set type appt
    } elseif {[ical_time extract_time $text start j1 j2]} {
        set finish [expr $start + 60*60]
        if {$finish > 24*60*60} {set finish [expr 24*60*60]}
        set type appt
    }

    if ![string compare $type notice] {
        set id [notice]
    } else {
        set id [appointment]
        $id starttime $date [expr $start/60]
        $id length    [expr ($finish - $start)/60]
    }

    $id date $date
    $id earlywarning [cal option DefaultEarlyWarning]
    $id own
    $id text $text
    return $id
}
