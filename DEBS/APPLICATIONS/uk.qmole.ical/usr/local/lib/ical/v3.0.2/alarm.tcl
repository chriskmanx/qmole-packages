# Copyright (c) 1993 by Sanjay Ghemawat
#######################################
#
# Alarms
#
# Rep
#       alarms          list of alarm times in minutes
#       pending         list of pending alarms;
#                           [<item> <fire time> <appt start time>]*
#       shutlist        list of item uids for which we said "shutup" in
#                       the last hour

class Alarmer {} {
    set slot(alarms)    [list 0 5 10 15]
    set slot(pending)   ""
    set slot(shutlist)  ""

    trigger on add      [list $self add]
    trigger on delete   [list $self remove]
    trigger on change   [list $self change]
    trigger on flush    [list $self recompute]

    # Start various threads
    $self recompute_thread
    $self fire_thread
    $self clear_shutup_thread
}

# Runs "Alarmer::recompute" once every six hours
method Alarmer recompute_thread {} {
    $self recompute
    after [expr 6*60*60*1000] [list $self recompute_thread]
}

# Set-up "Alarmer::fire" to run on next minute boundary
method Alarmer fire_thread {} {
    set msec [expr "(60-[ical_time second [ical_time now]])*1000"]
    if {$msec <= 0} {set msec 1}
    after $msec [list $self fire]
}

# Clears shutup list every hour
method Alarmer clear_shutup_thread {} {
    # Remove all shutup flags
    foreach n [array names slot shutup:*] {
        unset slot($n)
    }

    # Restore shutup flags set within the last hour so that we do
    # not lose recent shutups
    foreach uid $slot(shutlist) {
        set slot(shutup:$uid) 1
    }

    # Forget the shutup list for this past hour.  When this thread
    # runs again in an hour, it will clear out any shutup flags
    # that we just set.
    set slot(shutlist) ""

    # Reschedule
    after [expr 60 * 60 * 1000] [list $self clear_shutup_thread]
}

# effects - Recompute alarm list
method Alarmer recompute {} {
    # Incorporate new items
    set slot(alarms) [cal option DefaultAlarms]
    set slot(pending) ""

    set now [ical_time now]
    set today [date today]
    set midnight [$self midnight]

    cal query $today $today i d {
        if [$i is appt] {
            $self appt $i [expr $midnight+[$i starttime $today]*60] $now
        }
    }

    cal query [expr $today+1] [expr $today+1] i d {
        if [$i is appt] {
            $self appt $i [expr $midnight+(24*60*60)+[$i starttime [expr $today+1]]*60] $now
        }
    }
}

# effects - Merge newly added item into pending list
method Alarmer add {item} {
    if ![$item is appt] return
    if [cal option -calendar [$item calendar] IgnoreAlarms] return

    set now [ical_time now]
    set midnight [$self midnight]

    set today [date today]
    if [$item contains $today] {
        $self appt $item [expr $midnight+[$item starttime $today]*60] $now
    }

    if [$item contains [expr $today+1]] {
        $self appt $item [expr $midnight+(24*60*60)+[$item starttime [expr $today+1]]*60] $now
    }
}

# effects - Modify pending list to reflect change in specified item.
method Alarmer change {item} {
    $self remove $item
    $self add $item
}

# effects - Get time today started
method Alarmer midnight {} {
    set now [ical_time now]
    set split [ical_time split $now]
    set offset [expr "([lindex $split 0]*60*60 +\
                       [lindex $split 1]*60 +\
                       [lindex $split 2])"]

    return [expr $now-$offset]
}

# effects - Add appt to pending list
#       appt            appointment handle
#       time            time of occurrence
#       now             current time
method Alarmer appt {appt time now} {
    if [cal option -calendar [$appt calendar] IgnoreAlarms] return

    if [catch {set alarms [$appt alarms]}] {
        set alarms $slot(alarms)
    }

    foreach a $alarms {
        set t [expr $time-($a*60)]
        if {$t < $now} {
            continue
        }

        lappend slot(pending) $appt $t $time
    }
}

# effects - Remove pending entries for specified item
method Alarmer remove {item} {
    set pending ""
    foreach {x fire start} $slot(pending) {
        if {$x != $item} {
            lappend pending $x $fire $start
        }
    }
    set slot(pending) $pending
}

# effects - Shutup on alarms within the next hour for specified item
method Alarmer shutup {item} {
    # We set the shutup flag for this item, and also add it
    # to "shutlist" so that the shutup clearing thread will
    # leave this shutup flag alone the next time it runs
    set uid [list [$item uid] [$item text] [$item starttime [date today]]]
    set slot(shutup:$uid) 1
    lappend slot(shutlist) $uid
}

# effects - Fire pending alarms
method Alarmer fire {} {
    set pending ""

    # Fire alarms a little early (helps bypass round-off errors)
    set now [expr [ical_time now]+5]

    foreach {item fire start} $slot(pending) {
        if {$fire > $now} {
            # Not time to fire yet
            lappend pending $item $fire $start
            continue
        }

        # If alarms are shut off for this item, then ignore
        set uid [list [$item uid] [$item text] [$item starttime [date today]]]
        if [info exists slot(shutup:$uid)] {
            continue
        }

        # Close active notices
        trigger fire kill_alarm $item

        # Create alarm
        AlarmNotice $item $start
        run-hook alarm-fire $item
    }

    set slot(pending) $pending

    # Update clocks in notices
    trigger fire update_alarms

    # Set-up for next minute boundary
    $self fire_thread
}

#### Alarm notices ####

class AlarmNotice {item starttime} {
    set slot(item) $item
    set slot(starttime) $starttime

    toplevel .$self -class Reminder
    set_geometry {} .$self [option get .$self geometry Geometry]

    wm title .$self Reminder
    wm iconname .$self Reminder
    wm protocol .$self WM_DELETE_WINDOW [list AN_check_kill $self]

    # Buttons
    make_buttons .$self.bot 0\
        [list\
             [list {Snooze}             [list AN_check_kill $self]]\
             [list {No More Alarms}     [list AN_shutup $self]]]
                                   
    # Display
    set str [$item text]
    regsub -all "\n\$" $str "" str
    set lines [llength [split $str "\n"]]
    if {$lines < 4} {set lines 4}

    set st [time2text [$item starttime [date today]]]
    set fi [time2text [expr [$item starttime [date today]]+[$item length]]]


    frame .$self.top -class Pane
    label .$self.head -text "Appointment from $st to $fi"
    label .$self.foot -text ""

    text .$self.text -width 50 -height $lines -wrap word -relief groove
    .$self.text insert insert $str
    .$self.text configure -state disabled

    # Pack everything
    pack .$self.head -in .$self.top -side top -fill x
    pack .$self.text -in .$self.top -side top -padx 10m -pady 10m
    pack .$self.foot -in .$self.top -side bottom -fill x

    pack .$self.top -side top -expand 1 -fill x
    pack .$self.bot -side bottom -fill x

    # Key bindings
    # (took away the <Return> binding because some users window managers
    # were automatically giving the focus to the alarm, and the next
    # return would dismiss it.)
    bind .$self <Control-c> [list AN_check_kill $self]
    # bind .$self <Return> [list AN_check_kill $self]

    # Triggers
    trigger on delete           [list AN_item_kill $self]
    trigger on change           [list AN_item_kill $self]
    trigger on kill_alarm       [list AN_item_kill $self]
    trigger on flush            [list AN_check_kill $self]
    trigger on update_alarms    [list $self countdown]

    bell
}

method AlarmNotice destructor {} {
    trigger remove delete               [list AN_item_kill $self]
    trigger remove change               [list AN_item_kill $self]
    trigger remove kill_alarm           [list AN_item_kill $self]
    trigger remove flush                [list AN_check_kill $self]
    trigger remove update_alarms        [list $self countdown]

    destroy .$self
}

# These are not methods because they need to delete the notice

# effects  Kill the specified alarm notice and also remove any
#          pending alarms for the same item.
proc AN_shutup {object} {
    catch {alarmer shutup [$object item]}
    catch {class_kill $object}
}

# effects  Kill the specified alarm notice if it belongs to the
#          specified item.
proc AN_item_kill {object item} {
    catch {
        if ![string compare [$object item] $item] {
            class_kill $object
        }
    }
}

# effects  Kill the specified alarm notice if its corresponding item
#          no longer exists.
proc AN_check_kill {object} {
    # XXX Check whether or not item exists before killing.
    # XXX Check by uid/item contents instead of item handle to
    #     prevent false deletions when calendar is reread.
    catch {class_kill $object}
}

method AlarmNotice item {} {
    return $slot(item)
}

method AlarmNotice countdown {} {
    set now [ical_time now]
    if {$now > $slot(starttime)} {
        catch {.$self.foot configure -text "Late for Appointment"}

        # No more need for countdown triggers
        catch {trigger remove update_alarms [list $self countdown]}
    } else {
        set min [format "%.f" [expr ($slot(starttime)-$now)/60]]
        catch {.$self.foot configure -text "in $min minutes"}
    }
}

#### Create alarmer instance ####

proc start_alarmer {} {
    Alarmer-with-name alarmer
}

#### Test list ####

# + Alarms go off
# + Alarm notices aren't duplicated
# + Alarm notices count down properly
# + Item changes/deletions kill alarms
# + Item deletions by other calendar instances kills alarms
# + Shutup disables alarms
# + Shutup disables alarms even if calendar is modified by someone else
# + Shutup is overridden by changes
