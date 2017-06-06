# Copyright (c) 1993 by Sanjay Ghemawat
#############################################################################
# Printing dialog
#
# Commands
#
#       print_calendar <leader> <date>
#
#       Interact with user to print calendar contents.

# Hidden global variables
#
#       pr_done                 Is pr interaction finished
#       pr_count                Specification of how many days to print
#       pr_type                 Either "save", "print", or "preview"
#       pr_save                 Argument for "save"
#       pr_print                Argument for "print"
#       pr_preview              Argument for "preview"
#       pr_other                Argument for printing "other # of days"
#       pr_papersize            { SetUSLetter, SetA4Paper }
#
######################################################################
# Minor Changes added by Christopher A. Stoner on 5/30/95            #
# to allow printing of user entered days.                            #
# Added the global variable "other"                                  #
######################################################################

set pr_done 0

proc print_calendar {leader date} {
    pr_make
    pr_interact $leader $date
}

proc pr_make {} {
    set f .pr_dialog
    if [winfo exists $f] {return}

    global pr_done pr_count pr_type pr_save pr_print pr_preview pr_other
    global pr_papersize
    set pr_other 7
    set pr_count month
    set pr_type  print

    set pr_save    cal.ps
    set pr_print   "lpr"
    set pr_preview "ghostview -"
    set pr_papersize SetUSLetter
    catch {set pr_print   [cal option PrintCommand]}
    catch {set pr_preview [cal option PreviewCommand]}
    catch {set pr_papersize [cal option PrintPaperSize]}

    toplevel $f -class Dialog
    wm title $f Print
    wm protocol $f WM_DELETE_WINDOW {set pr_done 0}

    frame $f.top -class Pane
    frame $f.mid -class Pane
    frame $f.size -class Pane

    frame $f.top.l
    frame $f.top.r

    radiobutton $f.top.l.one -text "One Day"\
        -anchor w\
        -relief flat\
        -variable pr_count\
        -value 1
    radiobutton $f.top.l.two -text "Two Days"\
        -anchor w\
        -relief flat\
        -variable pr_count\
        -value 2
    radiobutton $f.top.l.six -text "Six Days"\
        -anchor w\
        -relief flat\
        -variable pr_count\
        -value 6

    radiobutton $f.top.r.nine -text "Nine Days"\
        -anchor w\
        -relief flat\
        -variable pr_count\
        -value 9
    radiobutton $f.top.r.twelv -text "Twelve Days"\
        -anchor w\
        -relief flat\
        -variable pr_count\
        -value 12
    radiobutton $f.top.r.month -text "Month"\
        -anchor w\
        -relief flat\
        -variable pr_count\
        -value month

    radiobutton $f.top.l.other -text "Other"\
        -anchor w\
        -relief flat\
        -variable pr_count\
        -value other
    
    frame $f.mid.save
    frame $f.mid.preview
    frame $f.mid.print

    radiobutton $f.mid.save.button -text "Save To"\
        -anchor w\
        -width 9\
        -relief flat\
        -variable pr_type\
        -command pr_update_entries\
        -value save
    radiobutton $f.mid.preview.button -text Preview\
        -anchor w\
        -width 9\
        -relief flat\
        -variable pr_type\
        -command pr_update_entries\
        -value preview
    radiobutton $f.mid.print.button -text Print\
        -anchor w\
        -width 9\
        -relief flat\
        -variable pr_type\
        -command pr_update_entries\
        -value print

    entry $f.mid.entry -width 15
    entry $f.top.r.entry -width 15 -textvariable pr_other

    radiobutton $f.size.letter -text "US Letter" \
        -anchor w\
        -relief flat\
        -variable pr_papersize\
        -value SetUSLetter
    radiobutton $f.size.a4 -text "A4 Paper" \
        -anchor w\
        -relief flat\
        -variable pr_papersize\
        -value SetA4Paper

    make_buttons $f.bot 1 {
        {Cancel         {set pr_done 0}}
        {Okay           {set pr_done 1}}
    }

    pack $f.top.l.one   -side top -fill x -padx 5m
    pack $f.top.l.two   -side top -fill x -padx 5m
    pack $f.top.l.six   -side top -fill x -padx 5m
    pack $f.top.r.nine  -side top -fill x -padx 5m
    pack $f.top.r.twelv -side top -fill x -padx 5m
    pack $f.top.r.month -side top -fill x -padx 5m
    pack $f.top.l.other -side top -fill x -padx 5m
    pack $f.top.r.entry -side top -fill x -padx 5m
    pack $f.top.l       -side left
    pack $f.top.r       -side right

    pack $f.mid.save.button     -side left -padx 5m
    pack $f.mid.preview.button  -side left -padx 5m
    pack $f.mid.print.button    -side left -padx 5m

    pack $f.mid.save    -side top -expand 1 -fill x
    pack $f.mid.preview -side top -expand 1 -fill x
    pack $f.mid.print   -side top -expand 1 -fill x

    pack $f.size.letter -side left -fill x -padx 5m
    pack $f.size.a4 -side left -fill x -padx 5m

    pack $f.top -side top -expand 1 -fill both
    pack $f.size -side top -fill both
    pack $f.mid -side top -fill both
    pack $f.bot -side bottom -fill both

    pr_update_entries

    bind $f <Control-c> {set pr_done 0}
    bind $f <Return>    {set pr_done 1}

    wm withdraw $f
    update
}

proc pr_update_entries {} {
    global pr_type

    set f .pr_dialog
    pack forget $f.mid.entry

    $f.mid.entry configure -textvariable pr_$pr_type
    pack $f.mid.entry -in $f.mid.$pr_type -side right -expand 1 -fill x
}

proc pr_interact {leader date} {
    global pr_type pr_save pr_preview pr_print pr_done pr_count
    global pr_papersize
    set f .pr_dialog

    # Run dialog
    set pr_done -1
    dialog_run $leader $f pr_done $f.mid.entry
    if !$pr_done {return}

    # Stash away printing commands
    if ![cal readonly] {
        cal option PrintCommand   $pr_print
        cal option PreviewCommand $pr_preview
        cal option PrintPaperSize $pr_papersize
    }

    # Get contents
    set output [pr_output $date $pr_count $pr_papersize]

    switch -exact -- $pr_type {
        save    { pr_file $pr_save $output }
        print   { pr_file "|$pr_print" $output }
        preview { pr_bg   $pr_preview $output }
        default { error "Unknown printing mode $pr_type" }
    }
}

proc pr_file {filespec data} {
    # effects   Write data to specified file.
    #           Make sure file gets closed on error.
    if [catch {
        set outfile [open $filespec w]
        # set the encoding to match the ps header
        fconfigure $outfile -encoding iso8859-1
        puts $outfile $data
        close $outfile
    } msg] {
        catch {close $outfile}
        error "Could not print to \"$filespec\"\n\n$msg"
    }

    catch {close $outfile}
}

proc pr_bg {cmd data} {
    # effects   Run command with specified input.
    if [catch {eval exec [list echo $data |] $cmd [list &]} msg] {
        error "$cmd failed:\n\n$msg"
    }
}

# effects - Return output file name
proc pr_outfile {} {
    global pr_type pr_save pr_preview pr_print

    # Stash away printing commands
    if ![cal readonly] {
        cal option PrintCommand   $pr_print
        cal option PreviewCommand $pr_preview
    }

    switch -exact -- $pr_type {
        save {
            set str $pr_save
        }
        preview {
            set str "|$pr_preview"
        }
        print {
            set str "|$pr_print"
        }
        default {
            error "Unknown printing mode $pr_type"
        }
    }

    return $str
}

# effects - Return postscript string
proc pr_output {date count papersize} {
    if ![string compare $count month] {
        set str [psmonth $date]
    } else {
        if ![string compare $count "other"] {
            global pr_other
            set count $pr_other
        }

        # Try to keep column width and row height similar
        set cols [expr round(sqrt($count * 11.0 / 8.5))]

        set str [psdays $date $count $cols 1]
    }
    
    set psheader [ps_header]
    set header "$papersize\n%%EndProlog\n%%Page: 1 1\ngsave\n"
    set trailer "\ngrestore\n%%Trailer\n%%Pages: 1"

    return "$psheader\n$header$str$trailer"
}
