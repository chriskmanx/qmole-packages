#############################################################################
# Dialog to get a pair of colors
#
# Commands
#
#       get_colors leader calname initial
#
proc get_colors {leader calname colors} {
    global gcolors
    set gcolors(done) -1
    set f .gcolors

    if ![winfo exists $f] {
        toplevel $f -class Dialog
        wm iconname $f Colors
        wm protocol $f WM_DELETE_WINDOW {set gcolors(done) 0}
        make_buttons $f.but 4 {
            {Foreground     get_fg}
            {Background     get_bg}
            {Reset          {set gcolors(done) 2}}
            {Cancel         {set gcolors(done) 0}}
            {Okay           {set gcolors(done) 1}}
        }

        message $f.help
        message $f.demo -text {Example: Check the mail}
        pack $f.help -side top -fill both -expand 1
        pack $f.demo -side top -fill x
        pack $f.but -side top -fill x
        update
        $f.help configure -width [expr [winfo width $f]*0.9]
        $f.demo configure -width [winfo width $f]

        bind $f <Control-c> {set gcolors(done) 0}
        bind $f <Return>    {set gcolors(done) 1}

        wm withdraw $f
    }

    $f.help configure \
            -text "Set the colors for all entries in the calendar '$calname' or reset them the to default values."
    wm title $f "Set Colors for $calname"

    set fg [lindex $colors 0]
    set bg [lindex $colors 1]
    if { $fg == "<Default>" || ![color_exists $fg]} {
        set fg [$f.help cget -foreground]
    }
    if { $bg == "<Default>" || ![color_exists $bg]} {
        set bg [$f.help cget -background]
    }
    $f.demo configure -foreground $fg -background $bg
    update
    wm minsize $f [winfo reqwidth $f] [winfo reqheight $f]
    dialog_run $leader $f gcolors(done)
    switch -- $gcolors(done) {
        0 { return {} }
        1 { return [list [$f.demo cget -foreground] [$f.demo cget -background]] }
        2 { return {<Default> <Default>} }
    }
}

proc get_fg {} {
    set c [tk_chooseColor -parent .gcolors \
                          -title Foreground \
                          -initialcolor [.gcolors.demo cget -foreground]]
    if { $c != "" } { .gcolors.demo configure -foreground $c }
}

proc get_bg {} {
    set c [tk_chooseColor -parent .gcolors \
                          -title Background \
                          -initialcolor [.gcolors.demo cget -background]]
    if { $c != "" } { .gcolors.demo configure -background $c }
}

