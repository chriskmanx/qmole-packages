# Copyright (c) 1993 by Sanjay Ghemawat
#############################################################################
# Various manipulations of a canvas

# effects - Foreach item "i" in canvas "c" with both tags "tag1" and "tag2",
#           add tag "newtag" to "i".
proc canvas_intersect_tags {c tag1 tag2 newtag} {
    set tmp __tmp_tag

    # First mark all items without "tag1" to have tag "tmp".
    $c addtag $tmp withtag all
    $c dtag $tag1 $tmp

    # Now mark all "tag2" items without tag "tmp" to have tag "newtag"
    $c addtag $newtag withtag $tag2
    $c dtag $tmp $newtag

    # Clean up
    $c dtag $tmp
}

# effects - Find beg-of-line that contains index "i" in canvas "c", item "x".
proc canvas_linestart {c x i} {
    set t [lindex [$c itemconfigure $x -text] 4]
    set p [expr [$c index $x $i]-1]
    while {($p >= 0) && ([string index $t $p] != "\n")} {
        incr p -1
    }
    incr p
    return $p
}

# effects - Find end-of-line that contains index "i" in canvas "c", item "x".
proc canvas_lineend {c x i} {
    set t [lindex [$c itemconfigure $x -text] 4]
    set p [$c index $x $i]
    set e [$c index $x end]
    while {($p < $e) && ([string index $t $p] != "\n")} {
        incr p
    }
    return $p
}
