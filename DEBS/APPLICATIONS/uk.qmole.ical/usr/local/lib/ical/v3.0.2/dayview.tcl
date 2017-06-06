# Copyright (c) 1993 by Sanjay Ghemawat
##############################################################################
# DayView
#
# DESCRIPTION
# ===========
# A DayView shows the notices and appointments for one day.

set dayview_id 0

class DayView {} {
    # Generate new id for window
    global dayview_id
    incr dayview_id
    set n .dayview$dayview_id
    set slot(window) $n
    set slot(sel)  {}

    global ical_state ical_view
    lappend ical_state(views) $self
    set ical_view($n) $self

    toplevel $n -class Dayview
    set_geometry {} $n [option get $n geometry Geometry]

    set slot(apptlist) [ApptList $n.al $self]
    set slot(notelist) [NoteList $n.nl $self]
    set slot(dateeditor) [DateEditor $n.de [date today] $self]

    frame $n.status -class Pane
    label $n.cal -text ""
    label $n.rep -text ""
    frame $n.menu -class Pane

    $self build_menu

    # Pack windows
    pack $n.cal         -in $n.status -side left
    pack $n.rep         -in $n.status -side right
    pack $n.menu        -side top -fill x
    pack $n.status      -side bottom -fill x
    pack $n.al          -side right -expand 1 -fill both
    pack $n.nl          -side bottom -expand 1 -fill both
    pack $n.de          -side top -fill x

    $self reconfig

    wm title $n Calendar
    wm iconname $n ical
    wm iconbitmap $n ical_icon
    wm protocol $n WM_DELETE_WINDOW [list ical_close_view $n]

    $self set_date [date today]

    # Set-up triggers.
    #
    # Save is not useful because dayview never keeps unsaved changes.
    # Add/delete/flush are not useful because we are only
    # interested in the currently selected item, and one of our
    # subwindows is going to tell us about it anyway.
    #
    # Therefore, we just need to listen for "change" so that we can
    # update the status window, and to "reconfig" so that we
    # can obey option changes.  We also need to listen for "midnight"
    # to automatically switch to next day.

    trigger on change   [list $self change]
    trigger on reconfig [list $self reconfig]
    trigger on midnight [list $self midnight]
    trigger on keybind  [list $self update_menu_accelerators]
    trigger on select   [list $self check_selection]

    # Set-up key bindings
    bindtags $n [list IcalUser $n IcalCommand Dayview all]

    # User customization
    ical_with_view $self {run-hook dayview-startup $self}

    # Do the following after user customization to handle user menus as well
    $self update_menu_accelerators
}

method DayView destructor {} {
    ical_with_view $self {run-hook dayview-close [ical_view]}

    # Remove from list of registered views
    global ical_state ical_view
    lremove ical_state(views) $self
    catch {unset ical_view($slot(window))}

    trigger remove change   [list $self change]
    trigger remove reconfig [list $self reconfig]
    trigger remove midnight [list $self midnight]
    trigger remove keybind  [list $self update_menu_accelerators]
    trigger remove select   [list $self check_selection]

    class_kill $slot(apptlist)
    class_kill $slot(notelist)
    class_kill $slot(dateeditor)
    destroy $slot(window)
}

##############################################################################
# Routines needed by action procs.

# Return the toplevel window for the view
method DayView window {} {
    return $slot(window)
}

# Return the displayed date
method DayView date {} {
    return $slot(date)
}

# Set the displayed date
method DayView set_date {date} {
    set slot(date) $date
    $slot(dateeditor) set_date $date
    $slot(apptlist) set_date $date
    $slot(notelist) set_date $date

    ical_with_view $self {run-hook dayview-set-date $self $date}
}

method DayView check_selection {args} {
    if [string compare [ical_view] $self] {
        # This is not the current view
        $self clear_selection
        return
    }

    if [catch {set i [ical_find_selection]}] {
        # No current selection
        $self clear_selection
        return
    }

    if ![string compare $i $slot(sel)] {
        # Already selected
        return
    }

    # Need to clear old selection
    $self clear_selection

    if [$i contains $slot(date)] {
        # Item exists on current date
        $self set_selection $i
    }
}

method DayView set_selection {item} {
    set slot(sel) $item
    $self config_status
}

method DayView clear_selection {} {
    set slot(sel) {}
    $self config_status
}

method DayView appt_list {} {return $slot(apptlist)}
method DayView note_list {} {return $slot(notelist)}

##############################################################################
# Trigger callbacks

# Called at midnight by a trigger.  Advance to today if appropriate.
method DayView midnight {} {
    # Only advance if at previous date
    set today [date today]
    if {$slot(date) == ($today-1)} {$self set_date $today}
}

method DayView change {item} {
    if {$slot(sel) == $item} {
        $self config_status
    }
}

method DayView reconfig {} {
    set name $slot(window)

    # Geometry management
    set width [winfo pixels $name "[cal option ItemWidth]c"]

    set start [cal option DayviewTimeStart]
    set finish [cal option DayviewTimeFinish]
    wm grid $name\
        1\
        [expr ($finish - $start) * 2]\
        $width\
        [$slot(apptlist) line_height]
    wm minsize $name 1 10
    wm maxsize $name 1 48
}

##############################################################################
# Internal helper procs

method DayView config_status {} {
    set item $slot(sel)
    if {$item == ""} {
        $slot(window).cal configure -text ""
        $slot(window).rep configure -text ""
    } else {
        set disp ""
        catch {set disp [ical_title [$item calendar]]}

        if {[$item hilite] == "holiday"} {
            set disp [format {%s Holiday} $disp]
        }

        set owner [$item owner]
        if {$owner != ""} {
            set disp [format {%s [Owner %s]} $disp $owner]
        }

        set type ""
        if [string compare [$item type] ""] {
            set type [$item describe_repeat]
            if {[string length $type] > 30} {
                set type "[string range $type 0 26]..."
            }
        }

        $slot(window).cal configure -text $disp
        $slot(window).rep configure -text $type
    }
}

# Update menu accelerator keys
method DayView update_menu_accelerators {} {
    global keymap
    foreach {seq cmd} $keymap(command)  {set key([lindex $cmd 0]) $seq}
    foreach {seq cmd} $keymap(item)     {set key([lindex $cmd 0]) $seq}

    # Also collect user defined key bindings
    catch {
        foreach {seq cmd} [cal option Keybindings] {
            set key([lindex $cmd 0]) $seq
        }
    }

    foreach m [winfo children $slot(window).menu] {
        set last [$m.m index last]
        for {set i 0} {$i <= $last} {incr i} {
            catch {
                set act [lindex [$m.m entrycget $i -command] 0]
                set seq {}
                catch {set seq "  [key_shortform $key($act)]"}
                $m.m entryconfig $i -acc $seq
            }
        }
    }
}

# Build the menu
method DayView build_menu {} {
    set b $slot(window).menu

    menu-entry  $b File Save                    {ical_save}
    menu-entry  $b File Re-Read                 {ical_reread}
    menu-entry  $b File Print                   {ical_print}
    menu-sep    $b File
    menu-entry  $b File {Include Calendar}      {ical_addinclude}
    menu-pull   $b File {Configure Calendar}    {ical_fill_config}
    menu-sep    $b File
    menu-entry  $b File {New Window}            {ical_newview}
    menu-entry  $b File {Close Window}          {ical_close}
    menu-sep    $b File
    menu-entry  $b File Exit                    {ical_exit}

    menu-entry  $b Edit {Cut Item}              {ical_cut_or_hide}
    menu-entry  $b Edit {Copy Item}             {ical_copy}
    menu-entry  $b Edit {Paste Item}            {ical_paste}
    menu-sep    $b Edit
    menu-entry  $b Edit {Delete Text}           {ical_delete_selection}
    menu-entry  $b Edit {Insert Text}           {ical_insert_selection}
    menu-sep    $b Edit
    menu-entry  $b Edit {Import Text as Item}   {ical_import}

    menu-bool   $b Item Todo                    {ical_toggle_todo}\
        dv_state(state:todo)
    menu-sep    $b Item
    $self fill_hilite $b Item
    menu-sep    $b Item
    menu-entry  $b Item {Link to Web Document}  {ical_link_to_uri}
    menu-entry  $b Item {Link to Local File}    {ical_link_to_file}
    menu-entry  $b Item {Remove Link}           {ical_remove_link}
    menu-sep    $b Item
    menu-entry  $b Item {Change Alarms...}      {ical_alarms}
    menu-entry  $b Item {Early Warning...}      {ical_set_remind}
    #menu-pull  $b Item {Move Item To}          {ical_fill_move}
    menu-sep    $b Item
    menu-entry  $b Item {Properties...}         {ical_edit_item}
    menu-sep    $b Item
    menu-entry  $b Item {Search Forward}        {ical_search_forward}
    menu-entry  $b Item {Search Backard}        {ical_search_backward}

    menu-entry  $b Repeat {Don't Repeat}        {ical_norepeat}
    menu-sep    $b Repeat
    menu-entry  $b Repeat {Daily}               {ical_daily}
    menu-entry  $b Repeat {Weekly}              {ical_weekly}
    menu-entry  $b Repeat {Monthly}             {ical_monthly}
    menu-entry  $b Repeat {Annually}            {ical_annual}
    menu-sep    $b Repeat
    menu-entry  $b Repeat {Edit Weekly...}      {ical_edit_weekly}
    menu-entry  $b Repeat {Edit Monthly...}     {ical_edit_monthly}
    menu-entry  $b Repeat {Set Range...}        {ical_set_range}
    menu-sep    $b Repeat
    menu-entry  $b Repeat {Last Occurrence}     {ical_last_date}
    menu-entry  $b Repeat {Make Unique}         {ical_makeunique}

    menu-entry  $b List {One Day}               {ical_list 1}
    menu-entry  $b List {Seven Days}            {ical_list 7}
    menu-entry  $b List {Ten Days}              {ical_list 10}
    menu-entry  $b List {Thirty Days}           {ical_list 30}
    menu-sep    $b List
    menu-entry  $b List {Week}                  {ical_list week}
    menu-entry  $b List {Month}                 {ical_list month}
    menu-entry  $b List {Year}                  {ical_list year}
    menu-sep    $b List
    menu-pull   $b List {From Calendar}         {ical_fill_listinc}

    menu-entry  $b Options {Appointment Range}    {ical_timerange}
    menu-entry  $b Options {Notice Window Height} {ical_noticeheight}
    menu-entry  $b Options {Item Width}           {ical_itemwidth}
    menu-entry  $b Options {Web Browser}          {ical_webbrowser}
    menu-sep    $b Options
    menu-bool   $b Options {Allow Text Overflow}  {ical_toggle_overflow}\
        dv_state(state:overflow)
    menu-bool   $b Options {Display Am/Pm}        {ical_toggle_ampm}\
        dv_state(state:ampm)
    menu-bool   $b Options {Start Week On Monday} {ical_toggle_monday}\
        dv_state(state:mondayfirst)
    menu-sep    $b Options
    menu-entry  $b Options {Default Alarms...}    {ical_defalarms}
    menu-entry  $b Options {Default Listings...}  {ical_deflistings}

    menu-sep    $b Options
    menu-entry  $b Options {Define a Command Key} {ical_edit_key}

    menu-entry  $b Help {About Ical}              {ical_about}
    menu-entry  $b Help {User Guide}              {ical_help}
    menu-entry  $b Help {Tcl Interface to Ical}   {ical_tcl_interface}

    # Move "Help" menu all the way to the right
    pack configure $b.help -side right
}

#############################################################################
# Commands to fill cascading menus

proc add_menu_command {menu title cmd} {
    $menu add command -label $title -command $cmd
}
proc add_menu_cascade {menu title cmd} {
    set i [$menu index last]
    set m $menu.submenu$i
    destroy $m
    menu $m -postcommand [concat $cmd $m] -tearoff 0
    $menu add cascade -label $title -menu $m
}

# effects - Fill menu with calendar names.
#           Invoke "<action> <calendar file>" when
#           menu entry is selected.

proc ical_fill_includes {add menu action {exclude_main ""}} {
    set list {}
    cal forincludes file {
        lappend list $file
    }

    $menu delete 0 last

    if ![string length $exclude_main] {
      $add $menu [ical_title [cal main]] [list $action [cal main]]
      $menu add separator
    }

    # Add menu separator whenever directory changes.
    set last_dir {}
    foreach f [lsort $list] {
        set d [file dirname $f]
        if [string compare $last_dir $d] {
            if [string compare $last_dir {}] {$menu add separator}
            set last_dir $d
        }
        $add $menu [ical_title $f] [list $action $f]
    }
}

# effects - fill config-menu for one calendar
proc fill_cal_config {cal menu} {
    variable cal_state
    set cal_state($cal:visible) [cal option -calendar $cal Visible]
    set cal_state($cal:ignorealarms) [cal option -calendar $cal IgnoreAlarms]

    $menu delete 0 last
    # the label is "hidden" instead of "visible" to have all checkboxes off by default
    $menu add checkbutton       -label "Hidden" -onvalue 0 -offvalue 1 -variable cal_state($cal:visible) -command [list ical_toggle_visible $cal]
    $menu add checkbutton       -label "Ignore Alarms" -onvalue 1 -offvalue 0 -variable cal_state($cal:ignorealarms) -command [list ical_toggle_ignorealarms $cal]
    $menu add command           -label "Color..." -command [list ical_change_colors $cal]
    $menu add command           -label "Rename" -command [list ical_rename $cal]
    #these two are only needed for non-ical calendars
    #$menu add command           -label "Default Highlight..."
    #$menu add command           -label "Default Time Zone..."
    if {$cal != [cal main]} {
        $menu add separator
        $menu add command       -label "Remove" -command [list ical_removeinc $cal]
    }
    set color [cal option -calendar $cal Color]
    set fg [lindex $color 0]
    set bg [lindex $color 1]
    if { $fg != "<Default>" && [color_exists $fg]} {
        $menu entryconfigure 2 -foreground $fg
    }
    if { $bg != "<Default>" && [color_exists $bg]} {
        $menu entryconfigure 2 -background $bg
    }
}

# effects - Fill configure-include menu
proc ical_fill_config {menu} {
    ical_fill_includes add_menu_cascade $menu fill_cal_config
}

# effects - Fill move-to-include menu
proc ical_fill_move {menu} {
    ical_fill_includes add_menu_command $menu ical_moveitem
}

# effects - Fill list-include menu
proc ical_fill_listinc {menu} {
    ical_fill_includes add_menu_command $menu ical_viewitems
}

# effects Fill hilite menu entries
method DayView fill_hilite {b m} {
    set entries {
        { {Always Highlight}    {always}        }
        { {Never Highlight}     {never}         }
        { {Highlight Future}    {expire}        }
        { {Holiday}             {holiday}       }
    }

    foreach e $entries {
        menu-oneof $b $m\
            [lindex $e 0]\
            [list ical_hilite [lindex $e 1]]\
            dv_state(state:hilite)\
            [lindex $e 1]
    }
}

#### Special code to set enablers for cascade menus ####
global ical_action_enabler
set ical_action_enabler(ical_fill_config)       writable
set ical_action_enabler(ical_fill_move)         witem
set ical_action_enabler(ical_fill_listinc)      always
