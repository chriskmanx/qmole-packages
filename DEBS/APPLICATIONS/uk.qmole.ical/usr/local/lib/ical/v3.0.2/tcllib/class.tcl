# Copyright (c) 1993 by Sanjay Ghemawat
#############################################################################
# Class system for Tcl.
#
# Implementation
# * Each object has a name of the form _o_<n> for some integer <n>.
# * _o_next is a global integer variable used for allocating object handles.
# * _o_<n> is a global array that stores the slots for _o_<n>.
# * _o_<n> is a procedure that dispatches to the appropriate methods.
# * <c>_ops is an array of class names indexed by method names.
# * superclass(c) is the name of the superclass for c.

# Initialize global variables
catch {unset _o_next}
set _o_next 0

catch {unset superclass}

# effects - Create class
proc class {name arglist body} {
    proc $name {args} [format {
        global _o_next
        incr _o_next
        set self _o_$_o_next
        _o_class_create %s $self
        eval [list %s.constructor %s $self] $args
        return $self
    } $name $name $name]

    proc $name-with-name {self args} [format {
        _o_class_create %s $self
        eval [list %s.constructor %s $self] $args
        return $self
    } $name $name $name]

    # Initialization routine
    method $name constructor $arglist $body

    # Default destructor routine for objects of this class does nothing
    method $name destructor {} {}

    # Return class name
    method $name class {} [format {return %s} $name]
}

# effects - Create subclass.
#
# Superclass constructor and destructor are NOT called by default.
# The subclass constructor and destructor should call them explicitly
# if necessary
proc subclass {name super arglist body} {
    # Make sure the super class is defined
    require $super

    # Inherit the superclass methods
    upvar #0 [set name]_ops sub_ops
    upvar #0 [set super]_ops super_ops

    # Record super-class name
    global superclass
    set superclass($name) $super

    foreach m [array names super_ops] {
        set sub_ops($m) $super_ops($m)
    }

    # Create subclass
    class $name $arglist $body
}

# effects - Delete object
#
# This cannot be a method because Tcl does not like active procs being
# deleted.
proc class_kill {object} {
    # Do object-specific cleanup
    global superclass
    set c [$object class]
    while 1 {
        $c.destructor $c $object
        if ![info exists superclass($c)] break
        set c $superclass($c)
    }

    # Reclaim storage
    rename $object {}
    global $object
    catch {unset $object}
}

# effects - Create method
proc method {class selector arglist body} {
    upvar #0 [set class]_ops ops
    set ops($selector) $class

    proc $class.$selector [linsert $arglist 0 selfclass self] [format {
        upvar #0 $self slot
        %s
    } $body]
}

# effects - Rename method from "old" to "new"
proc rename_method {class old new} {
    upvar #0 [set class]_ops ops
    set ops($new) $ops($old)
    unset ops($old)

    rename $class.$old $class.$new
}

# effects - Invoke selected method in superclass context
proc super {selector args} {
    global superclass
    upvar self self selfclass selfclass
    set sup $superclass($selfclass)
    upvar #0 ${sup}_ops ops

    return [uplevel [list $ops($selector).$selector $sup $self] $args]
}

# effects - Used internally for object creation.  Takes class name.
proc _o_class_create {C self} {
    upvar #0 $self slot
    catch {unset slot}
    set slot(junk) {}
    unset slot(junk)

    proc $self {sel args} [format {
        global %s_ops
        return [uplevel [list $%s_ops($sel).$sel $%s_ops($sel) %s] $args]
    } $C $C $C $self]
}

#### Making sure a proc is defined ####

proc require {procname} {
    if ![string compare [info commands $procname] $procname] return
    auto_load $procname
}
