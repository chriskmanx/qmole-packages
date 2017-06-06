# Copyright (c) 1996  by Sanjay Ghemawat
proc make_iconwindow {view} {
    set i ${view}_icon
    toplevel $i
    label $i.label
    pack $i.label
    every_minute [list update_icon_window $i]
    wm iconwindow $view $i
}

proc update_icon_window {i} {
    $i.label configure -text [time2text [ical_time minute [ical_time now]]]
}

proc every_minute {cmd} {
    eval $cmd
    set msec [expr "(60-[ical_time second [ical_time now]])*1000"]
    if {$msec <= 0} {set msec 1}
    after $msec every_minute $cmd
}
