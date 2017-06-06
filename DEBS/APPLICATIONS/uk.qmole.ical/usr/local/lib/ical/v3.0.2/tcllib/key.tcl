# Copyright (c) 1994 by Sanjay Ghemawat
#############################################################################
#
# Exported Procedures
#
#       key_shortform <seq>
#               Return short-form of key sequence
#
# Lower-Level Exported Procedures
#
# keyentry <widget>                     ; Create key sequence entry widget
# keyentry_get <widget>                 ; Return current contents of keyentry
# keyentry_set <widget> <seq>           ; Set keyentry contents

# effects - Make entry widget named $name into a key entry widget
proc keyentry {n} {
    global key
    set key($n,value) ""

    # Set-up key bindings for various modifier sequences
    bind $n <Key>               {keyentry_key %W <Key-%K>; break}
    bind $n <Control-Key>       {keyentry_key %W <Control-Key-%K>; break}
    bind $n <Meta-Key>          {keyentry_key %W <Meta-Key-%K>; break}
    bind $n <Control-Meta-Key>  {keyentry_key %W <Control-Meta-Key-%K>; break}
}

# effects - Return current contents of the key entry widget.
#           The returned value can be passed directly to a "bind"
#           command.  Note that the contents of the actual entry
#           widget are a short representation of the actual key
#           sequence and cannot be passed to a "bind" command.
proc keyentry_get {n} {
    global key
    return $key($n,value)
}

# effects - Set the contents of the entry widget.
proc keyentry_set {n value} {
    global key
    set key($n,value) $value
    keyentry_redisplay $n
}

# effects - Return short-form of specified key sequence.
#           The returned value CANNOT be used in a "bind" command.
#           It is only useful for presentation purposes.
proc key_shortform {seq} {
    regsub -all Key-     $seq ""  seq
    regsub -all Control- $seq C-  seq
    regsub -all Meta-    $seq M-  seq
    regsub -all {><}     $seq " " seq
    regsub -all {[<>]}   $seq "" seq
    return $seq
}

#############################################################################
# Internal procedures

proc keyentry_redisplay {name} {
    global key
    $name delete 0 end
    $name insert insert [key_shortform $key($name,value)]
}

proc keyentry_key {name k} {
    # Ignore keys like Alt_L, Meta_R, ...
    if [regexp {_[LR]>$} $k] {return}

    global key
    set key($name,value) "$key($name,value)$k"
    keyentry_redisplay $name
}
