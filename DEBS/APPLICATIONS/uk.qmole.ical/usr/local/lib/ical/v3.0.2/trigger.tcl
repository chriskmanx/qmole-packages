# Copyright (c) 1993 by Sanjay Ghemawat
###############################################################################
# Triggers
#
# Global Variables
#
#       trigger(type) is a list of strings to evaluate for a trigger with
#       the specified type.
#
# Common triggers
#
#       add     <item>          Called after adding item
#       text    <item>          Called after changing item text
#       change  <item>          Called after changing item
#       delete  <item>          Called before removing item
#       save
#       include <calendar>      Called after including calendar
#       exclude <calendar>      Called before excluding calendar
#       midnight                Called at midnight

proc trigger {cmd type args} {
    global trigger

    if {$cmd == "fire"} {
        set list ""
        catch {set list $trigger($type)}
        foreach str $list {
            eval $str $args
        }
        return
    }

    if {[llength $args] != 1} {
        error {wrong number of arguments to "trigger $type"}
    }
    set str [lindex $args 0]

    if {$cmd == "on"} {
        if [catch {lappend trigger($type) $str}] {
            # No triggers for type yet
            set trigger($type) [list $str]
        }
        return
    }

    if {$cmd == "remove"} {
        if ![catch {set list $trigger($type)}] {
            lremove list $str
            set trigger($type) $list
        }
        return
    }

    error {unknown command "trigger $type"}
}
