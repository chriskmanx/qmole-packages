# Copyright (c) 1993 by Sanjay Ghemawat
###############################################################################
# DateEditor
#
#       Allows interactive modification of a date.
#
# Description
# ===========
#
# A DateEditor displays a date and allows easy interactive modification
# of the date.  A command is executed whenever the date is modified.
#
# Note
# ====
#
# Code in dateeditor.C depends upon the tags assigned to canvas items.
# If you change the canvas layout, examine dateeditor.C

# effects - Creates date editor window $name.
#           Initial date is $date.
#           Every time the date is changed, an action is executed to
#           switch "view" to the new date.

class DateEditor {name date view} {
    set slot(window) $name
    set slot(date) $date
    set slot(view) $view
    set slot(offset) 0
    set slot(load) 0
    set slot(callback) 0
    set slot(pending) 0
    set slot(itemwidth) 1
    set slot(itemheight) 1
    set slot(hpad) 2
    set slot(vpad) 2

    # Layout the various components
    frame $name -class Dateeditor
    frame $name.top -class Pane
    frame $name.bot
    frame $name.mid -class Pane

    # The month selector
    frame $name.month
    label $name.month.label -text Month\
        -anchor center -width 9
    button $name.month.left -bitmap left_arrow -relief flat\
        -command {ical_last_month}
    button $name.month.right -bitmap right_arrow -relief flat\
        -command {ical_next_month}

    pack $name.month.left       -side left
    pack $name.month.right      -side right
    pack $name.month.label      -side left -expand 1 -fill both

    # The year selector
    frame $name.year
    label $name.year.label -text Year\
        -anchor center -width 4
    button $name.year.left -bitmap left_arrow -relief flat\
        -command {ical_last_year}
    button $name.year.right -bitmap right_arrow -relief flat\
        -command {ical_next_year}

    pack $name.year.left        -side left
    pack $name.year.right       -side right
    pack $name.year.label       -side left -expand 1 -fill both

    # Miscellaneous buttons
    button $name.last -text Prev\
        -command {ical_last_day}
    button $name.today -text Today\
        -command {ical_today}
    button $name.next -text Next\
        -command {ical_next_day}

    # The monthday selector
    set d $name.days
    canvas $d

    # Get dimensions for current date marker
    set slot(itemwidth)  [text_width  [pref weekdayFont] " 99"]
    set slot(itemheight) [text_height [pref weekdayFont] " 99"]

    # Get heading dimensions
    set slot(hw) [text_width  [pref weekdayFont] "Wed" $slot(hpad)]
    set slot(hh) [text_height [pref weekdayFont] "Wed" $slot(vpad)]
    $d configure -width [expr "$slot(hw)*7+4"] -height [expr "$slot(hh)*8"]

    set x [expr -$slot(hpad)]
    set y $slot(vpad)

    # Create monthdays
    foreach r {1 2 3 4 5 6} {
        foreach c {1 2 3 4 5 6 7} {
            $d create text\
                [expr "$x+($c*$slot(hw))"]\
                [expr "$y+(($r+1)*$slot(hh))"]\
                -text "$r$c" -anchor ne\
                -tags [list Day row$r col$c =[expr ($r-1)*7+$c]]\
                -fill [pref weekdayColor]\
                -font [pref weekdayFont]
        }
    }

    $d bind Day <1> [list $self day_select]

    # Create selection indicator
    $d create rect 0 0 5 5 -fill "" -outline [pref weekdayColor]\
        -width 2.0 -tags {marker}
    $d lower marker Day

    pack $name.month -in $name.top -side left -expand 1 -fill x
    pack $name.year  -in $name.top -side left -expand 1 -fill x

    pack $name.last  -in $name.bot -side left  -expand 1 -fill x
    pack $name.today -in $name.bot -side left  -expand 1 -fill x
    pack $name.next  -in $name.bot -side right -expand 1 -fill x

    pack $d -in $name.mid -side top

    pack $name.top -side top -expand 1 -fill x
    pack $name.mid -side top -expand 1 -fill both
    pack $name.bot -side top -expand 1 -fill x

    # Setup notification for item changes

    trigger on add      [list de_trigger_set $self]
    trigger on change   [list de_trigger_set $self]
    trigger on delete   [list de_trigger_set $self]
    trigger on flush    [list de_trigger_set $self]
    trigger on midnight [list de_trigger_set $self]
    trigger on reconfig [list $self reconfig]

    $self reconfig

    $self load_month
    $self set_selection
}

method DateEditor destructor {} {
    trigger remove add      [list de_trigger_set $self]
    trigger remove change   [list de_trigger_set $self]
    trigger remove delete   [list de_trigger_set $self]
    trigger remove flush    [list de_trigger_set $self]
    trigger remove midnight [list de_trigger_set $self]
    trigger remove reconfig [list $self reconfig]
}

# effects - Set up hilite recalculation to occur after
#           a small delay.  The delay is necessary because various
#           triggers may be fired before the corresponding calendar
#           state is changed.  The delay allows the calendar state
#           to be changed.
proc de_trigger_set {de args} {
    after 50 [list de_calc_run $de]
}

# Wrapper to handle dateeditor deletion
proc de_calc_run {obj} {
    if {[info procs $obj] != $obj} {
        return
    }
    $obj calc_hilite
}

method DateEditor reconfig {} {
    set d $slot(window).days
    set wnames {Sun Mon Tue Wed Thu Fri Sat}
    if [cal option MondayFirst] {
        set wnames {Mon Tue Wed Thu Fri Sat Sun}
    }

    $d delete Heading
    set col 1
    foreach w $wnames {
        set item [$d create text\
                        [expr "$col*$slot(hw)-$slot(hpad)"] $slot(vpad)\
                        -text $w -anchor ne\
                        -tags [list Heading]\
                        -fill [pref weekdayColor]\
                        -font [pref weekdayFont]]

        if {($w == "Sun") || ($w == "Sat")} {
            $d itemconfigure $item\
                -fill [pref weekendColor]\
                -font [pref weekendFont]
        }

        incr col
    }

    # Just configure all items to weekdayColor and weekdayFont
    $d itemconfigure Day -fill [pref weekdayColor] -font [pref weekdayFont]

    $self load_month
    $self set_selection
}

# effects - Reset dateeditor hilites because of item changes
method DateEditor calc_hilite {} {
    set name $slot(window)

    set c1 col7
    set c2 col1
    if [cal option MondayFirst] {set c2 col6}

    $name.days addtag holiday withtag $c1
    $name.days addtag holiday withtag $c2

    # Redo hilite lists
    set first [date make 1 [date month $slot(date)] [date year $slot(date)]]
    set last  [expr $first + [date monthsize $first] - 1]

    hilite_loop cal {holiday always} $first $last d h {
        $name.days addtag $h withtag =[expr [date monthday $d]+$slot(offset)]
    }

    canvas_intersect_tags $name.days holiday always holiday+always

    # Change colors
    $name.days itemconfig Day\
        -fill [pref weekdayColor] -font [pref weekdayFont]

    $name.days itemconfig holiday\
        -fill [pref weekendColor] -font [pref weekendFont]

    $name.days itemconfig always\
        -fill [pref interestColor] -font [pref interestFont]

    $name.days itemconfig holiday+always\
        -fill [pref weekendInterestColor] -font [pref weekendInterestFont]

    $name.days dtag holiday
    $name.days dtag always
    $name.days dtag holiday+always
}

# effects - Sets dateeditor contents for new month.
method DateEditor load_month {} {
    global month_name

    set date  $slot(date)
    set month [date month $date]
    set year  [date year  $date]

    set name $slot(window)
    $name.month.label configure -text $month_name($month)
    $name.year.label configure -text $year

    set first [date make 1 $month $year]
    set slot(offset) [expr [date weekday $first]-1]
    if [cal option MondayFirst] {
        set slot(offset) [expr ($slot(offset)+6)%7]
    }

    de_monthdays cal $name.days $date

    # Interest calculation
    $self calc_hilite
}

# effects - Set selection within month
method DateEditor set_selection {} {
    # Set selection
    set item =[expr [date monthday $slot(date)]+$slot(offset)]

    set name $slot(window)
    set coords [$name.days coords $item]
    $name.days coords marker\
        [expr [lindex $coords 0]+$slot(hpad)]\
        [expr [lindex $coords 1]]\
        [expr [lindex $coords 0]-$slot(itemwidth)]\
        [expr [lindex $coords 1]+$slot(itemheight)]
}

# Bindings

method DateEditor day_select {} {
    set name $slot(window)
    if {[$name.days type current] != "text"} {
        return
    }

    foreach tag [lindex [$name.days itemconfigure current -tags] 4] {
        if [string match "=*" $tag] {
            set day [expr [string range $tag 1 end]-$slot(offset)]
            if {($day < 1) || ($day > [date monthsize $slot(date)])} {
                return
            }
            ical_set_date [date make $day\
                               [date month $slot(date)]\
                               [date year $slot(date)]]
            return
        }
    }
}

method DateEditor set_date {date} {
    set old $slot(date)
    if {$old != $date} {
        # Make sure date can be rebuilt
        if [catch {date make\
                       [date monthday $date]\
                       [date month $date]\
                       [date year $date]} msg] {
            return
        }

        set slot(date) $date
        if {([date month $old] != [date month $date]) ||
            ([date year  $old] != [date year  $date])} {
            set slot(load) 1
        }
        set slot(callback) 1
        set slot(pending) [expr $slot(pending)+1]
        after 50 [list de_check $self]
    }
}

# Wrapper to handle DateEditor deletion
proc de_check {obj} {
    if {[info procs $obj] != $obj} {
        return
    }

    $obj check
}

method DateEditor check {} {
    set slot(pending) [expr $slot(pending)-1]
    if {$slot(pending) > 0} {
        return
    }
    set slot(pending) 0

    if $slot(load) {
        set slot(load) 0
        $self load_month
    }

    if $slot(callback) {
        set slot(callback) 0
        $self set_selection
    }
}
