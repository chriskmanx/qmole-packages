# @configure_input@
# Copyright (c) 1993 by Sanjay Ghemawat
###############################################################################
# Ical initialization.
#
# This code is linked into the ical binaries and executed at startup.

proc ical_init {} {
    set tv [info tclversion]
    if {[package vcompare $tv 7.5] < 0} {
        puts stderr "Ical requires at least Tcl version 7.5"
        exit 1
    }

    # Make sure there is "HOME" environment variable so that
    # tilde expansion does not blow up.
    global env
    if ![info exists env(HOME)] {set env(HOME) "/"}

    # Initialize options
    global ical
    set ical(author)            {sanjay@pa.dec.com}
    set ical(version)           {3.0.2}
    set ical(mailer)            {Mail}
    set ical(libparent)         {/usr/local/lib/ical}
    set ical(library)           {/usr/local/lib/ical/v3.0.2}
    set ical(startdate)         [date today]
    set ical(iconic)            0
    set ical(prefs)             {}
    set ical(geometry)          {}
    set ical(iconposition)      {}

    # Handle environment variables
    if [info exists env(ICAL_LIBRARY)] {set ical(library) $env(ICAL_LIBRARY)}
    if [info exists env(CALENDAR)] {
        set ical(calendar) $env(CALENDAR)
    } else {
        set ical(calendar) [ical_expand_file_name ~/.calendar]
    }

    # Auto-loading path
    global auto_path
    set auto_path [concat\
                   [list $ical(library) $ical(library)/tcllib]\
                   $auto_path]

    set have_tk [string compare [info commands tk] ""]
    support_init
    if $have_tk ical_tk_init
}

proc ical_tk_init {} {
    global tk_version
    if {[package vcompare $tk_version 4.1] < 0} {
        puts stderr "Ical requires at least Tk version 4.1"
        exit 1
    }

    # Handle geometry value already parsed by Tk
    global geometry ical
    if [info exists geometry] {set ical(geometry) $geometry}

    # Load Tk support code
    tk_support_init
}
