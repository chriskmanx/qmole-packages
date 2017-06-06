# Copyright (c) 1993 by Sanjay Ghemawat
##############################################################################
# ItemListing
#
# Description
# ===========
# Show item listing.

class ItemListing {} {
    set slot(nexttag) 1
    set slot(mainwindow) 0

    toplevel .$self -class Listing
    set_geometry [ical_leader] .$self [option get .$self geometry Geometry]

    wm title .$self "Calendar Items"
    wm iconname .$self "Items"
    wm protocol .$self WM_DELETE_WINDOW [list class_kill $self]

    # Done button
    make_buttons .$self.bot 0\
        [list [list {Okay} [list class_kill $self]]]

    # Move button to extreme right hand side.
    # XXX This depends on the internals of "make_buttons".
    pack .$self.bot.def0 -side right -expand 0

    # Display
    scrollbar .$self.scroll -orient vertical\
        -command [list .$self.display yview]
    text .$self.display\
        -setgrid 1\
        -relief raised\
        -bd 1\
        -yscrollcommand [list .$self.scroll set]\
        -width 50\
        -height 4\
        -wrap word

    # Pack it all up
    pack .$self.bot     -side bottom -fill x
    pack .$self.scroll  -side right  -fill y
    pack .$self.display -side left   -fill both -expand 1

    # Key bindings
    bind .$self <Control-c> [list class_kill $self]
    bind .$self <Return> [list class_kill $self]
    bind .$self.display <Double-1> [list $self null]
    bind .$self.display <Triple-1> [list $self null]

    # Tag displays
    .$self.display tag configure -date -font [pref smallHeadingFont]

    # Disallow edits
    .$self.display configure -state disabled
    $self resize
}

method ItemListing destructor {} {
    if $slot(mainwindow) {
        destroy .
    } else {
        destroy .$self
    }
}

# effects - Mark itemlisting as main window.  This causes the
#           program to finish when the itemlisting is dismissed
method ItemListing mainwindow {} {
    set slot(mainwindow) 1
}

# effects - do nothing
method ItemListing null {} {
}

# effects - Fill listing with items in specified date range.
method ItemListing dayrange {start finish} {
    # Allow edits temporarily
    .$self.display configure -state normal

    set sep  ""
    set date ""
    cal listing $start $finish i d {
        $self insert {} $sep
        if {$date != $d} {
            # New date
            set date $d
            $self insert {-date} "[date2text $date]\n"
        }

        $self insert {-item} [item2text $d $i "" "" 10000]
        set sep "\n"
    }

    # No more editing
    .$self.display configure -state disabled
    $self resize
}

# effects - Fill listing with items in specified calendar
method ItemListing calendar {calendar} {
    # Allow edits temporarily
    .$self.display configure -state normal

    set sep ""
    cal incalendar $calendar i {
        if [catch {set date [$i first]}] {
            continue
        }

        set tag tag.$slot(nexttag)
        incr slot(nexttag)

        $self insert {} $sep
        $self insert [list -date $tag] "[$i describe_repeat]\n"
        $self insert [list $tag] "[item2text $date $i {} {} 10000]"
        set sep "\n"

        .$self.display tag bind $tag <Double-Button-1> [list $self view $date]
    }

    # No more editing
    .$self.display configure -state disabled
    $self resize
}

# effects - Adjust size of window to size of contents
method ItemListing resize {} {
    set end [.$self.display index end]
    if ![regexp {^([0-9]+)\.([0-9]+)$} $end junk line char] {
        # Could not get text size!
        # Use default height
        set height 20
    } else {
        set height $line
        if {$height < 4} {
            set height 4
        }
        if {$height > 20} {
            set height 20
        }
    }
    .$self.display configure -height $height
}

# effects - Generate DayView for specified date.
method ItemListing view {date} {
    [ical_newview] set_date $date
}

# effects - Insert string with specified tags.
method ItemListing insert {tags str} {
    set start [.$self.display index insert]
    .$self.display insert insert $str

    # Remove existing tags
    foreach t [.$self.display tag names $start] {
        .$self.display tag remove $t $start insert
    }

    # Add new tags
    foreach t $tags {
        .$self.display tag add $t $start insert
    }
}

# effects - Return toplevel window for listing
method ItemListing window {} {
    return .$self
}
