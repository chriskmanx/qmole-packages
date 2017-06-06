# Copyright (c) 1993 by Sanjay Ghemawat
###############################################################################
# List generation support.

# effects - Return unparsing of date.
proc date2text {date} {
    global weekday_name month_name

    set split [date split $date]
    return [format "%s %s %d, %d"\
            $weekday_name([lindex $split 1])\
            $month_name([lindex $split 2])\
            [lindex $split 0]\
            [lindex $split 3]]
}

# effects - Return shorter unparsing of date.
proc date2text_no_weekday {date} {
    global month_name

    set split [date split $date]
    return [format "%s %d, %d"\
            $month_name([lindex $split 2])\
            [lindex $split 0]\
            [lindex $split 3]]
}

# effects - Return unparsing of time.
#           Time is number of minutes since midnight.
proc time2text {time} {
    set min [expr $time%60]
    set hour [expr ($time/60) % 24]

    set mer  ""
    if [cal option AmPm] {
        if {$hour >= 12} {
            set mer pm
            incr hour -12
        } else {
            set mer am
        }
        if {$hour == 0} {set hour 12}
    }

    return [format "%d:%02d%s" $hour $min $mer]
}

# effects - Return unparsing for item.
#           Lines are folded so that they are no longer than $wrap chars.
#           $header is prepended to beginning of appt.
#           $indent is prepended to beginning of every line except the first.
proc item2text {d item {header " * "} {indent "   "} {wrap 40}} {
    if [$item is appt] {
        set start [time2text [$item starttime $d]]
        set finish [time2text [expr [$item starttime $d]+[$item length]]]
        set header "$header$start to $finish\n$indent"
    }
    
    set str [$item text]
    
    # Wrap
    set out ""
    foreach line [split $str "\n"] {
        set out "$out[wrapline $line $wrap]"
    }
    set str $out
    
    # Strip trailing whitespace
    regsub -all "\[ \t\n\]+\$" $str "" str

    # Indent string
    regsub -all "\n" $str "\n$indent" str

    return "$header$str\n"
}

proc wrapline {line width} {
    set out ""
    set str ""
    set sep ""

    foreach word [split $line " \t"] {
        set str "$str$sep$word"
        if {[string length $str] > $width} {
            set str ""
            set sep "\n"
        } else {
            set sep " "
        }
        if {$out == ""} {
            set out $word
        } else {
            set out "$out$sep$word"
        }
    }

    return "$out\n"
}

# effects - Convert number to text
proc num2text {num} {
    set suff "th"

    # If second-last digit is not "1", then special case on the last digit.
    if {(($num/10)%10) != 1} {
        switch -exact -- [expr $num%10] {
            1 {set suff "st"}
            2 {set suff "nd"}
            3 {set suff "rd"}
        }
    }

    return "$num$suff"
}
