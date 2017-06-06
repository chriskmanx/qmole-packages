# Copyright (c) 1993 by Sanjay Ghemawat
#############################################################################
# File Selector Widget

proc FileSelector {n} {
    global fs

    set fs($n:directory) [_fs_canonicalize $n .]
    set fs($n:child)    {}
    set fs($n:all)      0

    # Create frame structure
    frame $n -class Inset
    make_selection_list $n.pbox $n.parents   Ancestors  left
    make_selection_list $n.cbox $n.children  Children   right
    $n.parents configure -width 18 -height 10
    $n.children configure -width 25 -height 10
    entry $n.entry
    checkbutton $n.showall -anchor w\
        -text {Show All Files}\
        -variable fs($n:all) -onvalue 1 -offvalue 0\
        -command [list _fs_rescan $n]

    # Pack up all the stuff
    pack $n.entry       -side bottom -expand 1 -fill x
    pack $n.showall     -side bottom -fill x
    pack $n.cbox        -side right  -expand 1 -fill both
    pack $n.pbox        -side top    -expand 1 -fill both

    # Some useful bindings
    bind $n.parents <ButtonRelease-1> [list _fs_parent $n]
    bind $n.children <ButtonRelease-1> [list _fs_change_file $n]
    bind $n.entry <space> [list _fs_complete $n]
    bind $n.entry <slash> [list _fs_complete_slash $n]

    # Initialization
    _fs_rescan $n
    _fs_setentry $n

    # Cleanup hook
    bind $n <Destroy> {_fs_cleanup %W}
}

proc fs_filename {n} {
    return [$n.entry get]
}

proc fs_goto {n str} {
    global fs

    if [catch {file isdirectory $str}] {
        # Tilde-expansion problems
        return
    }

    if [file isdirectory $str] {
        _fs_cd $n $str
        return
    }

    _fs_cd $n [file dirname $str]
    set fs($n:child) [file tail $str]
    _fs_setentry $n
}

# effects - Clean up
proc _fs_cleanup {n} {
    global fs
    unset fs($n:directory)
    unset fs($n:child)
    unset fs($n:all)
}

# effects - Return canonicalized version of $dir
proc _fs_canonicalize {n dir} {
    # Convert directory name to full file name
    if {$dir == ""} {set dir "/"}
    if {[string index $dir 0] == "~"} {
        # Perform tilde expansion
        catch {set dir [concat [file rootname $dir] [file extension $dir]]}
    }

    set leader [string index $dir 0]
    if {($leader != "~") && ($leader != "/")} {
        # Name is relative
        set dirlist [split $dir "/"]
        if [catch {set dir [pwd]}] {set dir /}

        foreach component $dirlist {
            if {$component != "."} {
                set dir "$dir/$component"
            }
        }
    }

    # Remove trailing /
    if {$dir != "/"} {
        regsub {/$} $dir "" dir
    }

    return $dir
}

# effects - Return file name for dir/child
proc _fs_descend {dir child} {
    if {$dir == "/"} {
        return "/$child"
    } else {
        return "$dir/$child"
    }
}

# effects - Set entry from directory/child
proc _fs_setentry {n} {
    global fs

    $n.entry delete 0 end
    $n.entry insert 0 [_fs_descend $fs($n:directory) $fs($n:child)]
}

# effects - Update listbox contents for dir
proc _fs_rescan {n} {
    global fs

    # Fill children list
    set dir $fs($n:directory)
    set contents {}
    if $fs($n:all) {
        catch {set contents [lsort [glob -nocomplain $dir/.* $dir/*]]}
    } else {
        catch {set contents [lsort [glob -nocomplain $dir/*]]}
        set tmp {}
        foreach file $contents {
            if ![string match *~ $file] {
                lappend tmp $file
            }
        }
        set contents $tmp
    }

    $n.children delete 0 end
    catch {
        foreach file $contents {
            $n.children insert end [file tail $file]
        }
    }

    # Fill parent list
    set ancestors {}
    catch {
        while {$dir != "/"} {
            set ancestors [linsert $ancestors  0 [file tail $dir]]
            set dir [file dirname $dir]
        }
        set ancestors [linsert $ancestors 0 "/"]
    }

    $n.parents delete 0 end
    foreach dir $ancestors {
        $n.parents insert end $dir
    }
}

proc _fs_cd {n dir} {
    global fs

    set fs($n:directory) [_fs_canonicalize $n $dir]
    set fs($n:child) ""
    _fs_rescan $n
    _fs_setentry $n
}

proc _fs_parent {n} {
    set sel [$n.parents curselection]
    if {[llength $sel] != 1} return
    set index [lindex $sel 0]

    set dir ""
    for {set i 1} {$i <= $index} {incr i} {
        set dir "$dir/[$n.parents get $i]"
    }
    if {$dir == ""} {set dir "/"}

    _fs_cd $n $dir
}

proc _fs_change_file {n} {
    global fs

    set sel [$n.children curselection]
    if {[llength $sel] != 1} return
    set file [$n.children get [lindex $sel 0]]

    set fs($n:child) $file
    set file [_fs_descend $fs($n:directory) $fs($n:child)]

    catch {
        if [file isdirectory $file] {
            _fs_cd $n $file
            return
        }
    }

    _fs_setentry $n
}

proc _fs_complete {n} {
    set str [$n.entry get]

    if [string match */ $str] {
        set str [string range $str 0 [expr [string length $str]-2]]
    }

    set complete ""
    catch {set complete [lsort [glob -nocomplain $str*]]}
    set len [llength $complete]
    if {$len == 1} {
        set str [lindex $complete 0]
    }

    fs_goto $n $str
    if {$len > 0} {
        _fs_scroll_child $n [file tail [lindex $complete 0]]
    }

    return -code break
}

# Scroll the child box to place strings that match "str" near the front
proc _fs_scroll_child {n str} {
    set clist [$n.children get 0 end]
    set i 0
    foreach entry $clist {
        if {[string compare $entry $str] >= 0} {
            $n.children see $i
            break
        }
        incr i
    }
}

proc _fs_complete_slash {n} {
    tkEntryInsert $n.entry /
    fs_goto $n [$n.entry get]
    return -code break
}
