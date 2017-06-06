# public_item.tcl ical plugin
# Copyright (C) 2005, 2006 Ethan Blanton <elb@elitists.net>
# Version 1.1
#
# This version requires my patch to ical to add context menus to items
# in the Day View.

action publical_toggle_item_public witem {Make item public} {} {
    if {![ical_with_mod_single_item i]} return
    set public 0
    catch {set public [$i option Public]}
    if {$public} {
        catch {$i delete_option Public}
    } else {
        $i option Public 1
    }
}

proc publical_cal_menu {menu} {
    global publical_cal_menu publical_cal_menu
    $menu delete 0 last
    catch {unset publical_cal_menu}
    set files [list [cal main]]
    cal forincludes file { lappend files $file }
    foreach file $files {
        set publical_cal_menu($file) 0
        catch {set publical_cal_menu($file) [cal option -calendar $file Public]}
        $menu insert last checkbutton -label [file tail $file] \
            -offvalue 0 -onvalue 1 -variable publical_cal_menu($file) \
            -command [list publical_toggle_cal_public $file]
    }
}

proc publical_toggle_cal_public {file} {
    set public 0
    catch {set public [cal option -calendar $file Public]}
    if {$public} {
        cal delete_option -calendar $file Public
    } else {
        cal option -calendar $file Public 1
    }
}

append-hook dayview-startup view {
    set menu [_menu_find [$view window].menu Item]
    $menu insert [expr {[$menu index Todo] + 1}] checkbutton \
        -label "Public" -offvalue 0 -onvalue 1 \
        -variable dv_state(state:public) \
        -command publical_toggle_item_public
    set menu [_menu_find [$view window].menu File]
    set cmd [list publical_cal_menu $menu.public]
    menu $menu.public -postcommand $cmd -tearoff 0
    $menu insert [expr {[$menu index {Remove Include}] + 1}] cascade \
        -label "Toggle Public" -menu $menu.public -command $cmd
}

append-hook item-select {item date} {
    global dv_state
    set public 0
    catch {set public [$item option Public]}
    set dv_state(state:public) $public
}

append-hook item-unselect {item date} {
    global dv_state
    set dv_state(state:public) 0
}

append-hook item-popup {item menu} {
    global dv_state
    $menu insert [expr {[$menu index Todo] + 1}] checkbutton \
        -label "Public" -offvalue 0 -onvalue 1 \
        -variable dv_state(state:public) \
        -command publical_toggle_item_public
}

set dv_state(state:todo) 0
