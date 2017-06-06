# Copyright (c) 1994 by Sanjay Ghemawat
#############################################################################
#
# Various ical actions invoked by menus and key bindings.
#
# The actions all take place in the context of a "view".  A "view"
# object should provide the following operations:
#
#       <view> window
#       <view> date
#       <view> set_date <date>

#### A null view to be used if nothing is selected ####

proc ical_null_view {method args} {
    switch -exact -- $method {
        window          {return .}
        date            {return [date today]}
        set_date        {}
        default         {error "unknown view method: $method"}
    }
}

#### Helper routines ####

proc ical_with_view {view body} {
    # XXX Error handling?
    uplevel $body
}

proc ical_view {} {
    global ical_view

    set f [ical_focus]
    if ![info exists ical_view($f)] {
        return ical_null_view
    } else {
        return $ical_view($f)
    }
}

proc ical_leader {} {
    global ical_state
    if ![string compare [ical_view] ical_null_view] {return ""}
    return [[ical_view] window]
}

proc ical_error {err} {
    error_notify [ical_leader] $err
}

proc ical_date {} {
    return [[ical_view] date]
}

proc ical_set_date {d} {
    [ical_view] set_date $d
}

proc ical_with_item {v} {
    if [catch {set item [ical_find_selection]}] {return 0}

    upvar $v i
    set i $item
    return 1
}

proc ical_with_mod_item {v} {
    if ![ical_with_item x] {return 0}

    if [catch {set cal [$x calendar]}] {return 0}
    if [cal readonly $cal] {
        ical_error "$cal: permission denied"
        return 0
    }

    upvar $v i
    set i $x
    return 1
}

proc ical_with_mod_single_item {v} {
    if ![ical_with_mod_item x] {return 0}

    set result [repeat_check [ical_leader] $x [ical_date]]
    if {$result == "cancel"} {return 0}

    upvar $v i
    set i $x
    return 1
}

proc ical_clip {i} {
    global ical_state
    set old $ical_state(clip)
    if [string compare $old ""] {
        $old delete
    }
    set ical_state(clip) $i
}

proc ical_clipped {} {
    global ical_state
    return $ical_state(clip)
}

#### Creating an action routine ####

proc action {name enabler title formals body} {
    global action_title ical_action_enabler
    set ical_action_enabler($name) $enabler
    set action_title($name) $title
    proc $name $formals $body
}

#### Action routines ####

action ical_newview always {Create new ical window} {} {
    global ical_state
    return [DayView]
}

action ical_save always {Save pending changes} {} {
    io_save [ical_leader]
}

action ical_reread always {Read changes made by other users} {} {
    io_read [ical_leader]
}

action ical_nop always {Do nothing} {} {
}

action ical_exit always {Kill ical} {} {
    if ![io_save [ical_leader]] return

    run-hook ical-exit
    cal delete
    destroy .
}

proc ical_close_view {window} {
    ical_focus_on $window
    ical_close
}

action ical_close always {Close ical window} {} {
    # Never try to delete the null view
    if ![string compare [ical_view] ical_null_view] return

    global ical_state
    if {[llength $ical_state(views)] < 2} {
        # Try and save --- last view is about to be closed
        if ![io_save [ical_leader]] return

        class_kill [ical_view]
        run-hook ical-exit
        cal delete
        destroy .
    } else {
        # Not the last view
        class_kill [ical_view]
    }
}


action ical_cut_or_hide item {Delete selected item} {} {
    if ![ical_with_item i] return

    if [catch {set cal [$i calendar]}] return
    if {[$i owned] || ($cal == [cal main])} {
        ical_cut
    } else {
        ical_hide
    }
}

action ical_cut witem {Delete selected item even if owned by another user} {} {
    if ![ical_with_mod_single_item i] return

    ical_clip $i
    cal remove $i
}

action ical_hide item {Hide selected item} {} {
    if ![ical_with_item i] return
    if [catch {set cal [$i calendar]}] return

    # Since the hide entry will go in the main calendar,
    # check for permission there.
    if [cal readonly] {
        ical_error "Permission denied"
        return
    }

    # Try to avoid checking permission in the item calendar
    # unless we have to split a repeating item.

    if [$i repeats] {
        if [cal readonly $cal] {
            # Tell user that the item cannot be split.
            # See if all entries should be hidden.
            if {![yes_or_no [ical_leader] [join {
                {This item repeats and you are not allowed to split it.}
                {Do you want to hide all occurrences of this item from}
                {your view?}
            }]]} {
                return
            }
        } else {
            if ![ical_with_mod_single_item i] return
        }
    }

    ical_clip [$i clone]
    cal hide $i
}

action ical_copy item {Copy selected item to clipboard} {} {
    if ![ical_with_item i] return
    ical_clip [$i clone]
}

action ical_paste writable {Paste clipboard item} {} {
    if [cal readonly] {
        ical_error "Permission denied"
        return
    }

    set i [ical_clipped]
    if {$i == ""} {
        ical_error "No item in clipboard"
        return
    }

    set i [$i clone]
    $i date [ical_date]
    $i own

    cal add $i
    run-hook item-create $i
}

action ical_delete_selection witem {Delete selected text} {} {
    if ![ical_with_mod_single_item i] return
    itemwindow_mod junk itemwindow_cut_selection
}

action ical_insert_selection witem {Delete selected text} {} {
    if ![ical_with_mod_single_item i] return
    itemwindow_mod junk itemwindow_insert_selection
}

action ical_import writable {Parse X selection as an item and add it to calendar} {} {
    if [catch {set sel [selection get]}] {return}

    if ![cal readonly] {
        set i [item_parse $sel [ical_date]]
        cal add $i
        run-hook item-create $i
        ical_set_date [$i first]
    }
}

action ical_makeunique witem {Create unique occurrence of selected item} {} {
    if ![ical_with_mod_item i] return
    if [catch {set cal [$i calendar]}] return
    if ![$i repeats] {
        ical_error "Item does not repeat"
        return
    }

    set c [$i clone]
    $c date [ical_date]
    $i deleteon [ical_date]
    cal add $c $cal
}

action ical_moveitem witem {Move item to another calendar} {calendar} {
    if [cal readonly $calendar] {
        ical_error "$calendar: permission denied"
        return
    }

    if ![ical_with_mod_single_item i] return
    cal add $i $calendar
}

action ical_addinclude writable {Include calendar} {} {
    if [cal readonly] {
        ical_error "[cal main]: permission denied"
        return
    }

    # Find last include file name and use as initial value for dialog
    global ical
    if ![info exists ical(last_include)] {
        set last [file dirname $ical(calendar)]
    } else {
        set last $ical(last_include)
    }
    if ![get_file_name [ical_leader] "Include Calendar"\
             "Select calendar file to include." filename $last] return
    set ical(last_include) [file dirname $filename]

    # Some sanity checking
    if [catch {set e [file exists $filename]} msg] {
        ical_error "$filename: $msg"
        return
    }

    if $e {
        if ![file isfile $filename] {
            ical_error "$filename: not a regular file"
            return
        }

        if ![file readable $filename] {
            ical_error "$filename: permission denied"
            return
        }
    }

    if [catch {cal include [ical_expand_file_name $filename]} error] {
        ical_error $error
    }
}

action ical_removeinc writable {Remove included calendar} {calendar} {
    if [cal readonly] {
        ical_error "[cal main]: permission denied"
        return
    }

    if [catch {set dirty [cal dirty $calendar]}] {
        # Unknown calendar - probably because a tear-off menu
        # allowed multiple invocations of removeinc.
        return
    }

    if $dirty {
        set save 1
        if [cal stale $calendar] {
            # Conflict!
            set query [yes_no_cancel [ical_leader]\
                       "$calendar has been modified since last read. Save?"]
            if {$query == "cancel"} {
                return
            }
            if {$query == "no"} {
                set save 0
            }
        }

        if $save {
            if [catch {cal save $calendar} error] {
                ical_error "$calendar\n\n$error"
                return
            }
        }
    }

    # Remove it
    if [catch {cal exclude $calendar} error] {
        ical_error "$calendar\n\n$error"
        return
    }
}

action ical_norepeat witem {Make item non-repeating} {} {
    if ![ical_with_mod_item i] return
    $i date [ical_date]
}

action ical_daily witem {Make item repeat daily} {} {
    if ![ical_with_mod_item i] return
    set d [ical_date]
    $i dayrepeat 1 $d
    $i start $d
}

action ical_monthly witem {Make item repeat monthly} {} {
    if ![ical_with_mod_item i] return
    set d [ical_date]
    $i month_day [date monthday $d]
    $i start $d
}

action ical_annual witem {Make item repeat yearly} {} {
    if ![ical_with_mod_item i] return
    set d [ical_date]
    $i month_day [date monthday $d] $d 12
    $i start $d
}

action ical_weekly witem {Make item repeat weekly} {} {
    if ![ical_with_mod_item i] return
    set d [ical_date]
    $i weekdays [date weekday $d]
    $i start $d
}

action ical_edit_monthly witem {Make item repeat monthly in a complicated way} {} {
    if ![ical_with_mod_item i] return
    monthrepeat [ical_leader] $i [ical_date]
}

action ical_edit_weekly witem {Make item repeat weekly in a complicated way} {} {
    if ![ical_with_mod_item i] return
    weekrepeat [ical_leader] $i [ical_date]
}

action ical_set_range witem {Restrict item repetition range} {} {
    if ![ical_with_mod_item i] return

    if ![$i repeats] {
        ical_error "Item does not repeat"
        return
    }

    if ![$i range start finish] {
        ical_error "Item does not repeat"
    }

    if ![get_daterange [ical_leader] start finish] return

    $i start $start
    $i finish $finish
}

action ical_last_date witem {Stop item repetition at this date} {} {
    if ![ical_with_mod_item i] return

    if ![$i repeats] {
        ical_error "Item does not repeat"
        return
    }
    $i finish [ical_date]
}

action ical_alarms wappt {Change appointment alarms} {} {
    if ![ical_with_mod_item i] return

    if [catch {set alarms [$i alarms]}] {set alarms [cal option DefaultAlarms]}
    if ![alarm_set [ical_leader] {Item alarms (in minutes)} alarms $alarms] {
        return
    }

    # Make sure item still exists
    catch {$i alarms $alarms}
}

action ical_edit_item witem {Edit item properties} {} {
    if ![ical_with_mod_item i] return
    item_edit [ical_leader] $i
}

action ical_link_to_file witem {Create a link to a file} {} {
    if ![ical_with_mod_item i] return

    # Try to get good initial file name
    set initial {}
    if ![catch {set link [$i option Link]}] {
        if [regexp {^file://localhost/(.*)$} $link junk filename] {
            set initial /$filename
        }
    }

    if ![get_file_name [ical_leader] "Item link"\
             "Select file to which link should be created."\
             filename $initial] return

    $i option Link file://localhost[ical_expand_file_name $filename]
}

action ical_link_to_uri witem {Create a link to a Web document} {} {
    if ![ical_with_mod_item i] return

    set initial {}
    catch {set initial [$i option Link]}

    if ![get_string [ical_leader] "Document Locator"\
             "Enter the uniform resource identifier of document"\
             $initial result] return
    $i option Link $result
}

action ical_remove_link witem {Remove any link from item} {} {
    if ![ical_with_mod_item i] return

    if [catch {$i delete_option Link} msg] {
        ical_error {Item does not contain a link}
    }
}

action ical_follow_link item {Follow link from item} {} {
    if ![ical_with_item i] return

    if [catch {set uri [$i option Link]}] {
        ical_error "Item does not have a link."
        return
    }

    follow_link $uri
}

action ical_deflistings writable {Set default value for item early warnings} {} {
    set num [cal option DefaultEarlyWarning]
    if [get_number [ical_leader] {Early warning}\
            {Days}\
            {By default items show up in item listings this many days early}\
            0 15 5 $num num] {
        cal option DefaultEarlyWarning $num
    }
}

action ical_remind witem {Set early warning option for item} {n} {
    if ![ical_with_mod_item i] return
    $i earlywarning $n
}

action ical_set_remind witem {Set early warning option for item} {} {
    if ![ical_with_mod_item i] return

    set num [$i earlywarning]
    if [get_number [ical_leader] {Early warning}\
            {Days}\
            {By default this item shows up in item listings this many days early}\
            0 15 5 $num num] {
        $i earlywarning $num
    }
}

action ical_set_owner witem {Change item owner} {} {
    if ![ical_with_mod_single_item i] return

    if ![get_string [ical_leader] "Owner" "Enter owner name"\
             [$i owner] result] return
    $i owner $result
}

action ical_hilite witem {Set highlight mode for item} {mode} {
    if ![ical_with_mod_single_item i] return
    $i hilite $mode
}

action ical_toggle_todo witem {Make item a todo item} {} {
    if ![ical_with_mod_single_item i] return
    $i todo [expr ![$i todo]]
}

action ical_toggle_done witem {Mark todo item as done} {} {
    if ![ical_with_mod_item i] return
    if [catch {set cal [$i calendar]}] return

    if ![$i todo] {
        ical_error "Item is not a todo item"
        return
    }

    if [$i is_done] {
        $i done 0
        return
    }

    set date [ical_date]

    # Make the current instance of the item unique
    if [$i repeats] {
        # XXX Make clone that does not occur on or before the current date
        set c [$i clone]
        $c start [expr $date+1]
        cal add $c $cal
    }

    # Modify this occurrence
    $i date $date
    $i done 1
    $i hilite never

    run-hook todo-item-done $i
}

action ical_print always {Print calendar contents} {} {
    if [catch {print_calendar [ical_leader] [ical_date]} msg] {
        ical_error $msg
    }
}

action ical_viewitems always {View all items from a calendar} {calendar} {
    set l [ItemListing]
    $l calendar $calendar
}

action ical_list always {List items from selected range of dates} {n} {
    set start [ical_date]
    if {$n == "week"} {
        set start [expr $start+1-[date weekday $start]]
        if [cal option MondayFirst] {
            incr start
            if {$start > [ical_date]} {
                set start [expr $start - 7]
            }
        }
        set n 7
    }
    if {$n == "month"} {
        set start [expr $start+1-[date monthday $start]]
        set n [date monthsize $start]
    }
    if {$n == "year"} {
        set start [date make 1 1 [date year $start]]
        set n [expr [date make 1 1 [expr [date year $start]+1]] - $start]
    }

    set l [ItemListing]
    $l dayrange $start [expr $start+$n-1]
}

action ical_toggle_overflow writable {Allow text to overflow appointment boundaries?} {} {
    if [cal readonly] {return}
    cal option AllowOverflow [expr ![cal option AllowOverflow]]
}

action ical_toggle_ampm writable {Display time with am/pm indicators?} {} {
    if [cal readonly] {return}

    cal option AmPm [expr ![cal option AmPm]]
    trigger fire reconfig
}

action ical_toggle_monday writable {Display Monday at the start of a week?} {} {
    if [cal readonly] {return}

    cal option MondayFirst [expr ![cal option MondayFirst]]
    trigger fire reconfig
}

action ical_rename writable {Change the calendar title} {calendar} {
    if [cal readonly $calendar] {return}

    if ![get_string [ical_leader] "Rename" "New name" [ical_title $calendar] t] {
        return
    }
    cal option -calendar $calendar Title $t
}

action ical_toggle_visible writable {Is the included calendar visible?} {calendar} {
    if [cal readonly $calendar] {return}

    cal option -calendar $calendar Visible [expr ![cal option -calendar $calendar Visible]]
    trigger fire flush
}

action ical_toggle_ignorealarms writable {Ignore all alarms from the included calendar?} {calendar} {
    if [cal readonly $calendar] {return}

    cal option -calendar $calendar IgnoreAlarms [expr ![cal option -calendar $calendar IgnoreAlarms]]
    trigger fire flush
}

action ical_change_colors writable {Asks to change calendar colors} {calendar} {
    if [cal readonly $calendar] {return}

    set colors [get_colors [ical_leader] [ical_title $calendar] [cal option -calendar $calendar Color]]
    if [llength $colors] {
        cal option -calendar $calendar Color "$colors"
    }
    trigger fire flush
}

action ical_timerange writable {Set the range of time initially displayed in a window} {} {
    if [cal readonly] {return}

    set start [cal option DayviewTimeStart]
    set finish [cal option DayviewTimeFinish]

    set msg [join {
        {Use the two sliders to change the range of time displayed by}
        {default in a Calendar window.}
    } "\n"]

    if [get_time_range [ical_leader] $msg start finish] {
        cal option DayviewTimeStart $start
        cal option DayviewTimeFinish $finish
        trigger fire reconfig
    }
}

action ical_noticeheight writable {Change the default height of the notice window} {} {
    if [cal readonly] {return}

    set ht [cal option NoticeHeight]
    if [get_number [ical_leader] {Notice Window Height}\
            {Centimeters}\
            {Specify the height of the notice window}\
            1 15 0 $ht ht] {
        cal option NoticeHeight $ht
        trigger fire reconfig
    }
}

action ical_itemwidth writable {Change the default width of the notice and appt windows} {} {
    if [cal readonly] {return}

    set w [cal option ItemWidth]
    if [get_number [ical_leader] {Item Width}\
            {Centimeters}\
            {Specify the width of appointments and notices}\
            5 15 0 $w w] {
        cal option ItemWidth $w
        trigger fire reconfig
    }
}

action ical_webbrowser writable {Change the default browser which is used for opening web links} {} {
    if [cal readonly] {return}

    set w netscape
    catch {set w [cal option WebBrowser]}
    if [get_string [ical_leader] {Web Browser} {Enter the path to the executable} $w w] {
        cal option WebBrowser $w
        trigger fire reconfig
    }
}

action ical_defalarms writable {Change default alarm settings} {} {
    if [cal readonly] {return}

    set alarms [cal option DefaultAlarms]
    if {![alarm_set [ical_leader]\
              {Default Alarms (in minutes)} alarms $alarms]} {
        return
    }

    cal option DefaultAlarms $alarms
    alarmer recompute
}

action ical_edit_key always {Change command key bindings} {} {
    if [cal readonly] {return}
    if [define_key [ical_leader] key] {
        ical_define_key $key
    }
}

proc ical_define_key {key} {
    # We want the map to be sorted and without duplicates
    catch {foreach {s c} [cal option Keybindings] {set val($s) $c}}
    set val([lindex $key 0]) [lindex $key 1]
    set map {}
    foreach key [lsort [array names val]] {
        if [string compare $val($key) ""] {
            lappend map $key $val($key)
        }
    }

    if [catch {cal option Keybindings $map} msg] {
        error_notify [ical_leader] $msg
    } else {
        trigger fire keybind
    }
}

action ical_gripe always {Gripe to the author of ical} {} {
    global ical
    bug_notify $ical(mailer) $ical(author) {Gripe}
}

action ical_help always {Display help on ical} {} {
    global ical
    Ical_Doc ical_doc
}

action ical_tcl_interface always {Display the Tcl interface to ical} {} {
    global ical
    Ical_Doc interface_doc
}

action ical_about always {Display information about this version of ical} {} {
    show_about [ical_leader]
}

#### Date change routines ####

action ical_last_month always {Move to previous month} {} {
    set split [date split [ical_date]]
    set month [lindex $split 2]
    set year [lindex $split 3]
    if {$month == 1} {
        set month 12
        incr year -1
    } else {
        incr month -1
    }

    # Handle range errors
    if [catch {set first [date make 1 $month $year]}] {return}

    # Adjust monthday to month size
    set day [lindex $split 0]
    if {$day > [date monthsize $first]} {set day [date monthsize $first]}

    ical_set_date [date make $day $month $year]
}

action ical_next_month always {Move to next month} {} {
    set split [date split [ical_date]]
    set month [lindex $split 2]
    set year [lindex $split 3]
    if {$month == 12} {
        set month 1
        incr year
    } else {
        incr month
    }

    # Handle range errors
    if [catch {set first [date make 1 $month $year]}] {return}

    # Adjust monthday to month size
    set day [lindex $split 0]
    if {$day > [date monthsize $first]} {set day [date monthsize $first]}

    ical_set_date [date make $day $month $year]
}

action ical_last_year always {Move to previous year} {} {
    set split [date split [ical_date]]
    set month [lindex $split 2]
    set year [lindex $split 3]
    incr year -1

    # Handle range errors
    if [catch {set first [date make 1 $month $year]}] {return}

    # Adjust monthday to month size
    set day [lindex $split 0]
    if {$day > [date monthsize $first]} {set day [date monthsize $first]}

    ical_set_date [date make $day $month $year]
}

action ical_next_year always {Move to next year} {} {
    set split [date split [ical_date]]
    set month [lindex $split 2]
    set year [lindex $split 3]
    incr year

    # Handle range errors
    if [catch {set first [date make 1 $month $year]}] {return}

    # Adjust monthday to month size
    set day [lindex $split 0]
    if {$day > [date monthsize $first]} {set day [date monthsize $first]}

    ical_set_date [date make $day $month $year]
}

action ical_today always {Move to today} {} {
    ical_set_date [date today]
}

action ical_last_day always {Move to previous day} {} {
    set date [expr [ical_date]-1]
    if {$date < [date first]} {return}
    ical_set_date $date
}

action ical_next_day always {Move to next day} {} {
    set date [expr [ical_date]+1]
    if {$date > [date last]} {return}
    ical_set_date $date
}

action ical_last_week always {Move to last week} {} {
    set date [expr [ical_date]-7]
    if {$date < [date first]} {return}
    ical_set_date $date
}

action ical_next_week always {Move to next week} {} {
    set date [expr [ical_date]+7]
    if {$date > [date last]} {return}
    ical_set_date $date
}

action ical_cycle_through_items always {Select next item} {} {
    set found_it 0
    if ![ical_with_item cur] {
        set cur {}
        set found_it 1
    }

    cal query [ical_date] [ical_date] i d {
        if $found_it {
            ical_select $i $d
            return
        }
        if ![string compare $i $cur] {set found_it 1}
    }

    ical_unselect
}

action ical_search_forward always {Search forward} {} {
    global ical_state
    set current [ical_date]

    set opat $ical_state(search)
    if ![get_string [ical_leader] "Search" "Enter search string" $opat pat] {
        return
    }
    set ical_state(search) $pat

    # Convert pattern to regular expression
    regsub -all {[^a-zA-Z0-9_]} $pat {\\&} pat

    if [ical_with_item cur] {
        # Special handling for current day
        set list {}
        cal query $current $current i d {
            lappend list $i
        }

        # Drop all items upto and including "cur"
        foreach i [lrange $list [expr [lsearch -exact $list $cur]+1] end] {
            if [regexp -nocase -- $pat [$i text]] {
                ical_select $i $current
                return
            }
        }
        incr current
    }
            
    # Get list of items we want to query over
    set list {}
    cal loop i {
        if [regexp -nocase -- $pat [$i text]] {
            lappend list $i
        }
    }

    # Now search for next occurrence
    cal loop_forward -items $list {} $current i d {
        ical_set_date $d
        ical_select $i $d
        return
    }

    error_notify [ical_leader] "No more items"
}

action ical_search_backward always {Search backward} {} {
    global ical_state
    set current [ical_date]

    set opat $ical_state(search)
    if ![get_string [ical_leader] "Search" "Enter search string" $opat pat] {
        return
    }
    set ical_state(search) $pat

    # Convert pattern to regular expression
    regsub -all {[^a-zA-Z0-9_]} $pat {\\&} pat

    if [ical_with_item cur] {
        # Special handling for current day
        set list {}
        cal query $current $current i d {
            lappend list $i
        }

        # Drop all items from "cur" onwards
        set last {}
        foreach i [lrange $list 0 [expr [lsearch -exact $list $cur]-1]] {
            if [regexp -nocase -- $pat [$i text]] {
                set last $i
            }
        }

        if [string compare $last {}] {
            ical_select $last $current
            return
        }

        incr current -1
    }

    # Get list of items we want to query over
    set list {}
    cal loop i {
        if [regexp -nocase -- $pat [$i text]] {
            lappend list $i
        }
    }

    # Now search for previous occurrence
    cal loop_backward -items $list {} $current i d {
        ical_set_date $d
        ical_select $i $d
        return
    }

    error_notify [ical_leader] "No more items"
}

