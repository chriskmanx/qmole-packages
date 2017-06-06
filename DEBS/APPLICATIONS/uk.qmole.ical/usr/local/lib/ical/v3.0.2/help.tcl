# Copyright (c) 1994 by Sanjay Ghemawat
##############################################################################
# Ical on-line help

class Ical_Doc {doc} {
    toplevel .$self
    wm iconname .$self help
    wm protocol .$self WM_DELETE_WINDOW [list class_kill $self]

    make_buttons .$self.bot 0 [list [list {Okay} [list class_kill $self]]]

    make_scrolled_text .$self.display
    set t .$self.display.text
    $t configure -setgrid 1 -wrap word -width 50 -height 30\
        -cursor top_left_arrow

    focus .$self
    bind .$self <Tab>       {break}
    bind .$self <Control-c> [list class_kill $self]
    bind .$self <space>     [list tkTextScrollPages $t 1]
    bind .$self <Control-f> [list tkTextScrollPages $t 1]
    bind .$self <Control-v> [list tkTextScrollPages $t 1]
    bind .$self <Control-b> [list tkTextScrollPages $t -1]
    bind .$self <Meta-v>    [list tkTextScrollPages $t -1]
    bind .$self <Delete>    [list tkTextScrollPages $t -1]
    bind .$self <BackSpace> [list tkTextScrollPages $t -1]

    # Set-up indentation
    set m [winfo pixels $t 20p]
    foreach i {1 2 3 4} {
        set i1 [expr ($i-1) * $m]
        set i2 [expr $i * $m]
        $t tag configure indent${i}h  -lmargin1 $i1 -lmargin2 $i2
        $t tag configure indent${i}   -lmargin1 $i2 -lmargin2 $i2
    }

    # Headers
    $t tag configure header1    -font [pref largeHeadingFont]
    $t tag configure header2    -font [pref smallHeadingFont] -underline 1
    $t tag configure header3    -font [pref smallHeadingFont]

    # Fonts
    $t tag configure norm       -font [pref normFont]
    $t tag configure bold       -font [pref boldFont]
    $t tag configure italic     -font [pref italFont]
    $t tag configure fixed      -font [option get . normFixedFont Font]
    $t tag configure boldfixed  -font [option get . boldFixedFont Font]
    $t tag configure pre        -font [option get . normFixedFont Font]\
                                -wrap none

    # References
    $t tag configure ref        -font [pref italFont]\
                                -foreground [pref interestColor]\
                                -underline 1

    # Insert documentation into text widget
    $doc $t
    $self make_toc
    $t configure -state disabled

    # Move button to extreme right hand side.
    # XXX This depends on the internals of "make_buttons".
    pack .$self.bot.def0 -side right -expand 0
    pack .$self.bot -side bottom -fill x

    pack .$self.display -expand 1 -fill both -side left
}

method Ical_Doc destructor {} {
    destroy .$self
}

method Ical_Doc goto_toc {} {
    catch {
        .$self.display.text yview header_[lindex [.$self.toc curselection] 0]
    }
}

# effects Generate table of contents in listbox from the contents of
#         a text widget.
method Ical_Doc make_toc {} {
    set t .$self.display.text
    set l .$self.toc

    listbox $l -relief raised -borderwidth 2 -exportselection 0\
        -font [pref boldFont]

    bind $l <ButtonRelease-1>   [list $self goto_toc]
    bind $l <B1-Motion>         [list $self goto_toc]

    # Prevent horizontal scrolling in toc
    bindtags $l [list YScan Listbox $l [winfo toplevel $l] all]

    # Prevent global binding from being run when button is pressed
    bindtags .$self.bot.b0 [list Button .$self.bot.b0 all]

    # Collect all headers
    set headers {}

    foreach level {1 2} {
        foreach {s f} [join [$t tag ranges header$level]] {
            set text [$t get $s $f]
            set pad $level
            while {$pad > 1} {
                set text "        $text"
                incr pad -1
            }
            lappend headers [list $s $text]
        }
    }

    # Sort headers by position in text
    set headers [lsort -command [list $self sort_by_pos] $headers]

    # Insert into box
    set i 0
    foreach {index text} [join $headers] {
        $l insert end $text
        $t mark set header_$i $index
        incr i
    }

    pack $l -fill y -side left
}

method Ical_Doc sort_by_pos {a b} {
    set a [lindex $a 0]
    set b [lindex $b 0]
    if {[.$self.display.text compare $a < $b]} {return -1}
    if {[.$self.display.text compare $a > $b]} {return  1}
    return 0
}

set about(done) 0
proc show_about {leader} {
    global ical about

    set t .about
    if ![winfo exists $t] {
        toplevel $t
        set font1 [pref largeHeadingFont]
        set font2 [pref smallHeadingFont]

        frame $t.top -class Pane
        frame $t.top.author
        label $t.top.version -font $font1 -text "Ical Version $ical(version)"

        label $t.top.author.l1 -font $font2 -text "Written by Sanjay Ghemawat"
        label $t.top.author.l2  -font $font2 -text $ical(author) -anchor e
        pack $t.top.author.l1 -side top -expand 1 -fill x
        pack $t.top.author.l2 -side top -expand 1 -fill x

        pack $t.top.version -side top -expand 1 -fill x -padx 5m -pady 5m
        pack $t.top.author  -side top -expand 1 -fill x -padx 5m -pady 5m

        make_buttons $t.bot 0 {
            {{Okay}             {set about(done) 1}}
        }

        pack $t.top -side top -expand 1 -fill x
        pack $t.bot -side bottom -expand 1 -fill x

        wm title $t {About Ical}
        wm protocol $t WM_DELETE_WINDOW {set about(done) 1}
        bind $t <Control-c> {set about(done) 1}
        bind $t <Return>    {set about(done) 1}

        wm withdraw $t
        update idletasks
    }

    set about(done) 0
    dialog_run $leader $t about(done)
    return
}
