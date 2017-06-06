# Copyright (c) 1993 by Sanjay Ghemawat
##############################################################################
# NoteList
#
#       Maintains list of notices for a certain date.
#
# Description
# ===========
# A NoteList displays notices for a particular date.

class NoteList {name view} {
    set slot(window) $name
    set slot(view) $view
    set slot(date) [date today]
    set slot(items) ""
    set slot(width) 100
    set slot(iwidth) 100
    set slot(sbar)  0

    frame $name -class NoteList
    canvas $name.c
    scrollbar $name.s -orient vertical -command [list $name.c yview]
    $name.c configure -yscrollcommand [list $self sbar_set]

    # Get font for this window
    set slot(font) [option get $name.c itemFont Font]
    if ![string compare $slot(font) ""] {
        set slot(font) [pref itemFont]
    }

    # Get font dimensions.  The text string "00:00AM" is used so that
    # we hit the cache entry created by "ApptList".
    set slot(font_height) [text_height $slot(font) "00:00AM" [pref itemPad]]

    $self configure
    $self background

    pack $name.c -side left -expand 1 -fill both

    # Establish bindings
    $name.c bind bg <1> [list $self new]
    bind $name.c <Configure> [list $self canvas_resize %w %h]
    bindtags $name.c [list IcalUser $name.c IcalItemEditBindings IcalItem IcalCommand]

    # Handle triggers
    trigger on add      [list $self change]
    trigger on delete   [list $self remove]
    trigger on change   [list $self change]
    trigger on text     [list $self textchange]
    trigger on flush    [list $self rescan]
    trigger on midnight [list $self rescan]
    trigger on reconfig [list $self reconfig]
}

method NoteList set_date {date} {
    set slot(date) $date
    $self rescan
    $slot(window).c yview moveto 0
}

# effects - Cleanup on destruction
method NoteList destructor {} {
    # We have to be very careful here about making sure callbacks do
    # not occur in the wrong place (i.e. on already deleted objects).

    # Remove triggers as soon as possible
    trigger remove add          [list $self change]
    trigger remove delete       [list $self remove]
    trigger remove change       [list $self change]
    trigger remove text         [list $self textchange]
    trigger remove flush        [list $self rescan]
    trigger remove midnight     [list $self rescan]
    trigger remove reconfig     [list $self reconfig]

    # Trim item list
    set list $slot(items)
    set slot(items) {}

    foreach item $list {
        catch {class_kill $slot(window.$item)}
    }

    destroy $slot(window)
}

##############################################################################
# Internal Procedures

method NoteList reconfig {} {
    set name $slot(window)
    set slot(width)  [winfo pixels $name "[cal option ItemWidth]c"]

    # Set canvas geometry
    $name.c configure\
        -width $slot(width)\
        -height "[cal option NoticeHeight]c"\
        -confine 1\
        -scrollregion [list 0 0 $slot(width) "[cal option NoticeHeight]c"]

    $name.c yview moveto 0
    $self layout
}

# effects - Compute various dimensions for NoteList
method NoteList configure {} {
    set name $slot(window)

    $self reconfig

    # Allow vertical scrolling with middle mouse button
    #$name.c bind all <2> [list $name.c scan mark 0 %y]
    #$name.c bind all <B2-Motion> [list $name.c scan dragto 0 %y]
}

method NoteList background {} {
    $slot(window).c create rectangle 0 0 1 1\
        -fill ""\
        -outline ""\
        -width 0\
        -tags bg
}

method NoteList new {} {
    # Check if something already selected on this view
    if ![catch {set i [ical_find_selection]} msg] {
        ical_unselect
        return
    }

    if [cal readonly] {
        error_notify [winfo toplevel $slot(window)] "Permission denied"
        return
    }

    set id [notice]
    $id date $slot(date)
    $id earlywarning [cal option DefaultEarlyWarning]
    $id own

    cal add $id
    ical_with_view $slot(view) {run-hook item-create $id}

    if [info exists slot(window.$id)] {
        ical_select $id $slot(date)
    }
}

method NoteList change {item} {
    if {[$item is note] && [$item contains $slot(date)]} {
        if [info exists slot(window.$item)] {
            $slot(window.$item) read
        } else {
            # Add item
            lappend slot(items) $item
            $self make_window $item
        }
        $self layout
        return
    }

    $self remove $item
}

method NoteList textchange {item} {
    if [info exists slot(window.$item)] {
        $slot(window.$item) read
        $self layout
    }
}

method NoteList remove {item} {
    set list $slot(items)
    if [lremove list $item] {
        set slot(items) $list
        $self kill $item
        $self layout
    }
}

method NoteList kill {item} {
    if ![info exists slot(window.$item)] return

    catch {class_kill $slot(window.$item)}
    catch {unset slot(window.$item)}
}

# args are ignored - they just allow trigger to call us directly.
method NoteList rescan {args} {
    set list $slot(items)
    set slot(items) ""

    foreach appt $list {
        $self kill $appt
    }

    set list {}
    cal query $slot(date) $slot(date) item d {
        if [$item is note] {
            lappend list $item
            $self make_window $item
        }
    }
    set slot(items) $list
    $self layout
}

method NoteList layout {} {
    set x [pref itemPad]
    set y 0
    foreach item $slot(items) {
        $slot(window.$item) geometry $x $y $slot(iwidth) 1
        set y [lindex [$slot(window.$item) bbox] 3]
    }
    incr y $slot(font_height)

    # Set canvas geometry
    $slot(window).c configure -scrollregion [list 0 0 $slot(width) $y]
}

# Adjust scrollbar.  Unpack it completely if the whole canvas is visible,
method NoteList sbar_set {first last} {
    if {($first > 0.0) || ($last < 1.0)} {
        # Need scrollbar
        if !$slot(sbar) {
            place $slot(window).s -relx 1 -rely 0 -anchor ne -relheight 1
            #pack $slot(window).s -side right -fill y
            set slot(sbar) 1
        }
    } else {
        if $slot(sbar) {
            place forget $slot(window).s
            #pack forget $slot(window).s
            set slot(sbar) 0
        }
    }

    $slot(window).s set $first $last
}

method NoteList make_window {item} {
    set slot(window.$item) [ItemWindow\
                                $slot(window).c\
                                $slot(font)\
                                $item $slot(date)]
}

method NoteList canvas_resize {w h} {
    set slot(iwidth) [expr $w - 2*[pref itemPad]]
    $slot(window).c coord bg 0 0 $w [expr $slot(font_height)*100]
    $self layout
}
