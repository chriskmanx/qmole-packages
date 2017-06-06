# Copyright (c) 1996  by Sanjay Ghemawat
#############################################################################
# Menu operations
#
#       menu-entry      <menubar> <menu title> <label> <command>
#       menu-bool       <menubar> <menu title> <label> <command> <var>
#       menu-oneof      <menubar> <menu title> <label> <command> <var> <value>
#       menu-pull       <menubar> <menu title> <label> <post command>
#       menu-sep        <menubar> <menu title>

# effects Create menu command entry in menu labelled "title".
#         The menu entry has the label "label" and executes "command".
proc menu-entry {menubar title label command} {
    set menu [_menu_find $menubar $title]
    catch {$menu delete $label}
    $menu add command -label $label -command $command
}

# effects Create menu checkbutton entry in menu labelled "title".
#         The menu entry has the label "label" and executes "command".
#         The menu entry is displayed in a selected style iff "var" is 1.
proc menu-bool {menubar title label command var} {
    set menu [_menu_find $menubar $title]
    catch {$menu delete $label}
    $menu add checkbutton\
        -label $label\
        -offvalue 0\
        -onvalue 1\
        -variable $var\
        -command $command
}

# effects Create menu radiobutton entry in menu labelled "title".
#         The menu entry has the label "label" and executes "command".
#         The menu entry is displayed in a selected style iff
#         "var" is "value".
proc menu-oneof {menubar title label command var value} {
    set menu [_menu_find $menubar $title]
    catch {$menu delete $label}
    $menu add radiobutton\
        -label $label\
        -value $value\
        -variable $var\
        -command $command
}

# effects Create a cascading pull-right menu
proc menu-pull {menubar title label postcommand} {
    set menu [_menu_find $menubar $title]
    catch {$menu delete $label}

    set i [$menu index last]
    set cascade $menu.submenu$i
    set cmd [concat $postcommand [list $cascade]]
    menu $cascade -postcommand $cmd -tearoff 0

    $menu add cascade -label $label -menu $cascade -command $cmd
}

# effects Create menu separator entry in menu labelled "title".
proc menu-sep {menubar title} {
    set menu [_menu_find $menubar $title]
    $menu add separator
}

#############################################################################
# Internal routines

# effects Find menu labelled "title" in current menubar.  Create the
#         menu if no such menu exists yet.  Returned the created menu
#         window id.
proc _menu_find {menubar title} {
    set menu $menubar.[string tolower $title]
    if ![winfo exists $menu] {
        menubutton $menu -text $title -menu $menu.m
        menu $menu.m
        pack $menu -side left
    }
    return $menu.m
}
