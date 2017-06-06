# Copyright?
#
# Week number list extension for Ical
# Revision 1.1 31-5-1995
# Created by : Norbert Erkeland (etmnoer@crosby.ericsson.se)
# Edited by  : Sanjay Ghemawat (sanjay@pa.dec.com)
#
# Source this code from user.tcl

#### Definitions of useful routines for older versions of ical ####
if [string compare [info commands require] require] {
    proc require {proc} {
        if ![string compare [info commands $proc] $proc] return

        global auto_index
        if [info exists auto_index($proc)] {
            uplevel #0 $auto_index($proc)
        }
    }
}

if [string compare [info commands rename_method] rename_method] {
    proc rename_method {class old new} {
        upvar #0 [set class]_ops ops
        set ops($new) $ops($old)
        unset ops($old)

        rename $class::$old $class::$new
    }
}

# Override the "load_month" method on date editors
require DateEditor
rename_method DateEditor load_month orig_load_month

method DateEditor load_month {} {
    $self orig_load_month

    if ![winfo exists $slot(window).weeknums] {
        $self make_weeknums
    }
    $self update_weeknums
}

#### Create week number display ####
method DateEditor make_weeknums {} {
    set w $slot(window)
    set c $w.days
    set n $w.weeknums
    set m $w.mid

    set height [lindex [$c configure -height] 4]
    canvas $n -relief raised -borderwidth 1 -width 50 -height $height

    # Redo the packing and configuration
    $c configure -relief raised -borderwidth 1
    $m configure -borderwidth 0
    pack $n -in $m -side left -fill y -ipadx 1m
    pack $c -in $m -side left

    set wd_box_h [expr $height/8]
    $n create text 5 2\
        -fill [pref weekdayColor]\
        -anchor nw\
        -font [pref weekdayFont]\
        -tags {wd_week}\
        -text "Week"
    set wd_start [wd_first $slot(date)]
    set wd_mod [lindex $wd_start 1]
    set wd_start [lindex $wd_start 0]
    set wd_cnt 0
    while {$wd_cnt < 6} {
        set wd_wknr [expr ($wd_start + $wd_cnt) % $wd_mod]
        if {$wd_wknr < [expr $wd_start + $wd_cnt]} {incr wd_wknr}
        $n create text 30 [expr 2+(2+$wd_cnt)*$wd_box_h]\
            -fill [pref weekdayColor]\
            -anchor ne\
            -font [pref weekdayFont]\
            -tags [list wd_week$wd_cnt]\
            -text "$wd_wknr"
        incr wd_cnt
    }
    set wd_cnt [wd_last $slot(date)]
    while {$wd_cnt < 6} {
        $n itemconfigure wd_week$wd_cnt -fill [pref itemBg] 
        incr wd_cnt
    }                 
}

#### Update week number display ####
method DateEditor update_weeknums {} {
    set n $slot(window).weeknums
    set wd_start [wd_first $slot(date)]
    set wd_mod [lindex $wd_start 1]
    set wd_start [lindex $wd_start 0]
    set wd_cnt 0
    while {$wd_cnt < 6} {
        set wd_wknr [expr ($wd_start + $wd_cnt) % $wd_mod]
        if {$wd_wknr < [expr $wd_start + $wd_cnt]} {incr wd_wknr}
        $n itemconfigure wd_week$wd_cnt -text "$wd_wknr"\
            -fill [pref weekdayColor]
        incr wd_cnt
    }             

    set wd_cnt [wd_last $slot(date)]
    while {$wd_cnt < 6} {
        $n itemconfigure wd_week$wd_cnt -fill [pref itemBg]
        incr wd_cnt
    }
}

proc wd_first {date} {
    set wd_year [date year $date]
    set wd_first [date make 1 1 $wd_year]
    set wd_days 0
    set wd_first [date weekday $wd_first]
    if {$wd_first == 1} {set wd_first 8}
    set wd_month [date month $date]
    set wd_cnt 1
    while {$wd_cnt < $wd_month} {
        if ![catch {date make 1 $wd_cnt $wd_year}] {
           set wd_days [expr $wd_days + [date monthsize [date make 1 $wd_cnt $wd_year]]]
        } else {
           set wd_days 30
        }
        incr wd_cnt
    }
    incr wd_days
    # The ISO year corresponds approximately to the Gregorian year, but weeks start on Monday and end on Sunday.
    # The first week of the ISO year is the first such week in which at least 4 days are in a year. 
    set wd_prev_year [expr $wd_year - 1]
    set wd_prev_days 0
    set wd_cnt 1
    while {$wd_cnt <= 12} {
          if ![catch {date make 1 $wd_cnt $wd_prev_year}] {
             set wd_prev_days [expr $wd_prev_days + [date monthsize [date make 1 $wd_cnt $wd_prev_year]]]
          } else {
             set wd_prev_days 30
          }
          incr wd_cnt
    }
    if ![catch {date make 1 1 $wd_prev_year}] {
       set wd_prev_first [date weekday [date make 1 1 $wd_prev_year]]
    } else {
       set wd_prev_first 1
    }
    if {$wd_prev_first == 1} {set wd_prev_first 8}

    if {$wd_prev_first > 5} {
       set wd_prev_days [expr $wd_prev_days - (9-$wd_prev_first)]
    } else {
       set wd_prev_days [expr $wd_prev_days + ($wd_prev_first-2)]
    }    
    if {($wd_first > 5)} {
       set wd_prev_days [expr $wd_prev_days + (9-$wd_first)]
       set wd_days [expr $wd_days - (9-$wd_first)]
       if {$wd_month == 1} {
          if {($wd_first == 8) && ([cal option MondayFirst] == 0)} {
             return [list 1 [expr (($wd_prev_days-1) / 7) + 2]]
          } else {
             return [list [expr (($wd_prev_days-1) / 7) +1] [expr (($wd_prev_days-1) / 7) + 2]]
          }
       }
    } else {
       set wd_prev_days [expr $wd_prev_days - ($wd_first-2)]
       set wd_days [expr $wd_days + ($wd_first-2)]
    }   
    if {$wd_month == 12} {
       set wd_prev_days [expr $wd_days - 7 + [date monthsize $date]]
       if ![catch {date make 1 1 [expr $wd_year +1]}] {
          set wd_prev_first [date weekday [date make 1 1 [expr $wd_year + 1]]]
       } else {
          set wd_prev_first 1
       }
       if {$wd_prev_first > 5} {
          set wd_prev_days [expr $wd_prev_days + (9-$wd_prev_first)]
       } else {
          set wd_prev_days [expr $wd_prev_days - ($wd_prev_first-2)]
       }
    } else {
       set wd_prev_days [expr 53*7]
    } 
    if {([date weekday [date make 1 $wd_month $wd_year]] == 1) && ([cal option MondayFirst] == 0)} {
       return [list [expr (($wd_days-1) / 7) + 2] [expr (($wd_prev_days - 1) / 7) + 2]] 
    } else {   
       return [list [expr (($wd_days-1) / 7) + 1] [expr (($wd_prev_days - 1) / 7) + 2]]
    }
}

proc wd_last {date} {
    set wd_last [date monthsize $date]
    if [cal option MondayFirst] {
       set wd_last [expr $wd_last+(([date weekday [date make 1 [date month $date] [date year $date]]]+5) % 7) - 1]
    } else {
       set wd_last [expr $wd_last+(([date weekday [date make 1 [date month $date] [date year $date]]]) -2 )]
    }
    expr ($wd_last / 7) + 1 
}
