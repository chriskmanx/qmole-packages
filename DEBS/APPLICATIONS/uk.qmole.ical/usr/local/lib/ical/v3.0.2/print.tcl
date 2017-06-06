# Copyright (c) 1993 by Sanjay Ghemawat
#############################################################################
# Print calendar contents

proc psmonth {date} {
    global month_name

    set m [date month $date]
    set y [date year $date]
    set start [date make 1 $m $y]
    set finish [date make [date monthsize $date] $m $y]

    set output {}

    lappend output {                SetLandScape}
    lappend output {7               SetGridWidth}
    lappend output {5               SetGridHeight}
    lappend output {0.5 inch        SetBorderWidth}
    lappend output {0.3 inch        SetBorderHeight}
    lappend output {0.5 inch        SetHeaderHeight}
    lappend output {0.1 inch        SetHeaderSep}
    lappend output {10              SetMinLines}
    lappend output {15              SetMaxLines}
    lappend output {0.3 inch        SetColumnHeight}
    lappend output {0.1 inch        SetColumnSep}
    lappend output {0.25            SetTitleFraction}
    lappend output {10              SetFontHeight}
    lappend output "($month_name($m), $y) SetHeaderLeft"

    ps_printtime output
    lappend output {ComputeLayout}

    set col [expr [date weekday $start] - 1]
    set row 0

    if [cal option MondayFirst] {
        lappend output {0       ()      (Mon)   ()      ColumnHead}
        lappend output {1       ()      (Tue)   ()      ColumnHead}
        lappend output {2       ()      (Wed)   ()      ColumnHead}
        lappend output {3       ()      (Thu)   ()      ColumnHead}
        lappend output {4       ()      (Fri)   ()      ColumnHead}
        lappend output {5       ()      (Sat)   ()      ColumnHead}
        lappend output {6       ()      (Sun)   ()      ColumnHead}
        set col [expr ($col + 6) % 7]
    } else {
        lappend output {0       ()      (Sun)   ()      ColumnHead}
        lappend output {1       ()      (Mon)   ()      ColumnHead}
        lappend output {2       ()      (Tue)   ()      ColumnHead}
        lappend output {3       ()      (Wed)   ()      ColumnHead}
        lappend output {4       ()      (Thu)   ()      ColumnHead}
        lappend output {5       ()      (Fri)   ()      ColumnHead}
        lappend output {6       ()      (Sat)   ()      ColumnHead}
    }

    set num 1
    for {set d $start} {$d <= $finish} {incr d} {
        # Print date header
        lappend output [format "%d %d () (%2d)" $row $col $num]

        ps_printday output $d

        lappend output {ShowDay}

        incr num
        incr col
        if {$col == 7} {
            set col 0
            incr row
            if {$row == 5} {set row 0}
        }
    }

    lappend output {showpage}

    return [join $output "\n"]
}

proc psdays {start num cols landscape} {
    set wdays {{} Sun Mon Tue Wed Thu Fri Sat}
    set mons  {{} Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec}

    set finish [expr $start + $num - 1]
    set year1 [date year $start]
    set year2 [date year $finish]
    set rows [expr ($num + $cols - 1) / $cols]

    set output {}

    if $landscape {
        lappend output {SetLandScape}
    } else {
        lappend output {SetPortrait}
    }

    lappend output "$cols SetGridWidth"
    lappend output "$rows SetGridHeight"

    lappend output {0.5 inch        SetBorderWidth}
    lappend output {0.3 inch        SetBorderHeight}
    lappend output {0.5 inch        SetHeaderHeight}
    lappend output {0.1 inch        SetHeaderSep}
    lappend output {18              SetMinLines}
    lappend output {18              SetMaxLines}
    lappend output {0.1             SetTitleFraction}

    if {$year1 != $year2} {
        lappend output "($year1 - $year2) SetHeaderLeft"
    } else {
        lappend output "($year1) SetHeaderLeft"
    }

    ps_printtime output
    lappend output {ComputeLayout}

    set col 0
    set row 0
    for {set d $start} {$d <= $finish} {incr d} {
        lappend output [format "%d %d (%s) (%s %d)"\
                        $row $col\
                        [lindex $wdays [date weekday $d]]\
                        [lindex $mons  [date month $d]]\
                        [date monthday $d]]

        ps_printday output $d
        lappend output {ShowDay}

        incr col
        if {$col == $cols} {
            set col 0
            incr row
        }
    }

    lappend output {showpage}

    return [join $output "\n"]
}

#############################################################################
# Internal operations

proc ps_printtime {o} {
    upvar $o output

    # Get time/date
    set now [ical_time now]
    set date [date2text [date today]]
    set time [time2text [expr [ical_time minute $now] + [ical_time hour $now]*60]]

    # Get user
    set user ""
    catch {set user " by [exec whoami]"}

    # Save old parameters
    lappend output {BorderHeight}
    lappend output {HeaderHeight}
    lappend output {HeaderLeft}
    lappend output {HeaderRight}

    # Print
    lappend output {HeaderHeight 2 div SetHeaderHeight}
    lappend output {()                 SetHeaderLeft}
    lappend output "(Printed $date, $time$user) SetHeaderRight"
    lappend output {gsave ComputeLayout grestore}

    # Restore old parameters
    lappend output {SetHeaderRight}
    lappend output {SetHeaderLeft}
    lappend output {SetHeaderHeight}
    lappend output {SetBorderHeight}
}

proc ps_printday {o date} {
    upvar $o output

    lappend output "\["

    cal query $date $date item junk {
        lappend output "\["

        # Print all the lines
        set text [item2text $date $item "" "" 2000]
        regsub -- "\n\$" $text "" text
        regsub -all -- {[()\\]} $text {\\&} text
        set lines [split $text "\n"]

        # Put extra space at end of all strings to help out the line breaker.
        lappend output [format {(%s )} [join $lines " )\n("]]

        lappend output "\]"
    }

    lappend output "\]"
}
