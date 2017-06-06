# Copyright (c) 1994 by Sanjay Ghemawat
#############################################################################
# Hook mechanisms
#
# Commands
#
#       create-hook     <hook>
#       run-hook        <hook> [<args>...]
#       append-hook     <hook> {<argspec>} {<body>}
#       prepend-hook    <hook> {<argspec>} {<body>}
#
#       obsolete-hook   <hook> [explanation]
#
# Example
#
#       create-hook dayview-startup
#       ...
#       append-hook dayview-startup {view} {
#           wm title [$view window] SpecialTitle
#       }
#       ...
#       run-hook dayview-startup $view
#
# Global Variables
#
#       hook            Array of hook lists.  Each hook list is a list
#                       of procedure names.
#
#       hook_obsolete   Array indexed by hook names.  Each hook
#                       with an entry in this array is considered obsolete.
#
#       hookid          Integer for generating unique procedure names.

catch {unset hook}
catch {unset hookid}
catch {unset hook_obsolete}

set hook(junk) {}
unset hook(junk)
set hook_obsolete(junk) {}
unset hook_obsolete(junk)
set hookid 0

proc create-hook {name} {
    global hook
    if [info exists hook($name)] {error "hook $name already exists"}
    set hook($name) {}
}

proc append-hook {name argspec body} {
    if ![_hook_check $name] return

    global hook hookid
    if ![info exists hook($name)] {error "no hook named $name"}

    incr hookid
    proc _hook_$hookid $argspec $body

    lappend hook($name) _hook_$hookid
}

proc prepend-hook {name argspec body} {
    if ![_hook_check $name] return

    global hook hookid
    if ![info exists hook($name)] {error "no hook named $name"}

    incr hookid
    proc _hook_$hookid $argspec $body

    set hook($name) [linsert $hook($name) 0 _hook_$hookid]
}

proc run-hook {name args} {
    global hook hookid
    if ![info exists hook($name)] {error "no hook named $name"}

    foreach h $hook($name) {
        if [catch {eval $h $args} msg] {
            error_notify "" "Error running hook \"$name\"\n\n$msg"
        }
    }
}

proc obsolete-hook {name {explain {}}} {
    global hook_obsolete
    set hook_obsolete($name) $explain
}

proc _hook_check {name} {
    global hook_obsolete
    if [info exists hook_obsolete($name)] {
        set msg "Hook $name is obsolete."
        if [string compare $hook_obsolete($name) ""] {
            set msg "$msg  $hook_obsolete($name)."
        }
        error $msg
        return 0
    }
    return 1
}
