# Copyright (c) 1993 by Sanjay Ghemawat
###############################################################################
# Calendar IO
#
# Save every "saveSeconds".
# Read every "pollSeconds".

# effects       Create threads for saving and reading.
proc io_thread {} {
    io_loop {io_save} [expr [pref saveSeconds]*1000]
    io_loop {io_read} [expr [pref pollSeconds]*1000]
}

# effects       Execute "cmd" every "interval" milliseconds.
proc io_loop {cmd interval} {
    eval $cmd
    after $interval io_loop $cmd $interval
}

# effects       Save all modified calendars.  Return true iff
#               successfully saved everything.
#
#               May interact with the user if there are conflicting
#               changes to a calendar.
#
#               Any dialogs are centered over the "leader" window.
#               If "leader" is the empty string, then the dialogs
#               are centered on the screen.

proc io_save {{leader {}}} {
    foreach file [ical_filenames] {
        if ![cal dirty $file] {continue}

        if [cal stale $file] {
            set msg "$file has been modified since last read. Write anyway?"
            set query [yes_no_cancel $leader $msg]

            if {$query == "cancel"} {return 0}
            if {$query == "no"} {continue}

            # If user said "yes", fall through and save.
        }
        
        if [catch {cal save $file} error] {
            error_notify $leader "$file\n\n$error"
            return 0
        }
    }
    return 1
}

# effects       Re-read modified calendars.  Returns true iff
#               successfully reread everything.
#
#
#               May interact with the user if there are conflicting
#               changes to a calendar.
#
#               Any dialogs are centered over the "leader" window.
#               If "leader" is the empty string, then the dialogs
#               are centered on the screen.

proc io_read {{leader {}}} {
    # Cannot use [ical_filenames] because main calendar may change
    # in the middle of the iteration.

    if [catch {set read_main [io_read_one [cal main] $leader]}] {
        # Failure
        return 0
    }

    cal forincludes file {
        if [catch {io_read_one $file $leader} msg] {
            # Failure
            return 0
        }
    }

    if $read_main {
        # Tell views to reconfigure themselves
        trigger fire reconfig
    }

    return 1
}

# effects       Read one calendar.
#               Returns 1 if calendar was actually read.
#               Returns 0 if calendar was not read.
#               Raises an error if reading the calendar failed for some reason.

proc io_read_one {file leader} {
    if ![cal stale $file] {return 0}

    if [cal dirty $file] {
        set msg "$file has been modified locally. Discard changes?"
        set query [yes_no_cancel $leader $msg]

        if {$query == "cancel"} {return 0}
        if {$query == "no"} {return 0}

        # Fall through and read the calendar
    }

    if [catch {cal reread $file} error] {
        error_notify $leader "$file\n\n$error"
        error $error
    }

    return 1
}
