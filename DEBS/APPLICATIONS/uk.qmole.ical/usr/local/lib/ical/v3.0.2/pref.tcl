# Copyright (c) 1993 by Sanjay Ghemawat
###############################################################################
# User Preferences

# Autload support
proc pref {type} {
    # Dispatch to appropriate method
    return [pref_$type]
}

proc pref_load_common {} {
    option add *fontFamily              times           startupFile
    option add *fixedFontFamily         courier         startupFile
    option add *Font                    fixed           startupFile
    option add *fontSize                normal          startupFile

    option add *saveSeconds             30              startupFile
    option add *pollSeconds             120             startupFile

    option add *itemPad                 2               startupFile
    option add *Reminder.geometry       +400+0          startupFile
    option add *Listing.geometry        +400+0          startupFile

    option add *Dayview*takeFocus       0               startupFile

    option add *ApptList.Canvas.Relief                  raised  startupFile
    option add *ApptList.Canvas.highlightThickness      0       startupFile

    option add *NoteList.Canvas.Relief                  raised  startupFile
    option add *NoteList.Canvas.highlightThickness      0       startupFile
}

proc pref_load_color {} {
    set fg      [pref_findcolor black]
    set bg      [pref_findcolor gray80 white]
    set wday    [pref_findcolor black $fg]
    set wend    [pref_findcolor red $fg]
    set int     [pref_findcolor blue $fg]
    set wendint [pref_findcolor purple $fg]
    set line    $fg
    set ifg     $fg
    set ibg     [pref_findcolor gray75 $bg white]
    set isfg    $fg
    set isbg    [pref_findcolor LightSkyBlue $bg white]
    set over    [pref_findcolor DeepSkyBlue $bg white]
    set csbg    [pref_findcolor khaki $fg]

    if [catch {set disabled [pref_findcolor gray60]}] {
        set disabled ""
    }

    option add *weekdayColor            $wday           startupFile
    option add *weekendColor            $wend           startupFile
    option add *interestColor           $int            startupFile
    option add *weekendInterestColor    $wendint        startupFile
    option add *apptLineColor           $line           startupFile

    option add *itemFg                  $ifg            startupFile
    option add *itemBg                  $ibg            startupFile
    option add *itemSelectFg            $isfg           startupFile
    option add *itemSelectBg            $isbg           startupFile
    option add *itemSelectWidth         0               startupFile
    option add *itemOverflowColor       $over           startupFile
    option add *itemOverflowStipple     {}              startupFile
    option add *Canvas*selectBackground $csbg           startupFile

    option add *ApptList.Canvas.BorderWidth     1       startupFile
    option add *NoteList.Canvas.BorderWidth     1       startupFile
}

proc pref_load_mono {} {
    option add *Foreground              black           startupFile
    option add *Background              white           startupFile

    option add *weekdayColor            black           startupFile
    option add *weekendColor            black           startupFile
    option add *interestColor           black           startupFile
    option add *weekendInterestColor    black           startupFile
    option add *apptLineColor           black           startupFile

    option add *itemFg                  black           startupFile
    option add *itemBg                  white           startupFile
    option add *itemSelectFg            black           startupFile
    option add *itemSelectBg            white           startupFile
    option add *itemSelectWidth         4               startupFile
    option add *itemOverflowColor       black           startupFile
    option add *itemOverflowStipple     gray50          startupFile

    option add *ApptList.Canvas.BorderWidth     2       startupFile
    option add *NoteList.Canvas.BorderWidth     2       startupFile
}

proc pref_init {} {
    global preference
    option clear
    tcllib_load_options

    # Load default options
    pref_load_common
    if [string match *color* [winfo screenvisual .]] {
        pref_load_color
    } else {
        pref_load_mono
    }

    pref_fixfonts

    # Cache various entries
    set preference(itemPad)     [winfo pixels . [option get . itemPad Size]]

    # Use command-line geometry specification (if any)
    global geometry
    if ![catch {set geometry}] {
        # Specified on command line
        option add Ical.Dayview.geometry $geometry
    }

    # XXX People do not seem to like the motif-style popup behavior
#    global tk_strictMotif
#    if {!$tk_strictMotif} {
#       bind Menubutton <Any-ButtonRelease-1> {tkMenuUnpost {}}
#    }

    # Handle command line preferences
    global ical
    foreach pref $ical(prefs) {eval $pref}
}

# Fix fonts in option database
proc pref_fixfonts {} {
    global preference
    set ff [option get . fontFamily String]
    set preference(norm_fontfamilies) [concat [list $ff] {
        times
        charter
        {new century schoolbook}
        courier
        helvetica
    }]

    set ff [option get . fixedFontFamily String]
    set preference(fixed_fontfamilies) [concat [list $ff] {
        courier
        fixed
        terminal
        lucidatypewriter
    }]

    switch -exact -- [option get . fontSize String] {
        small {
            set size1   120
            set size2   120
            set size3   140
            set size4   180
        }
        default {
            set size1   120
            set size2   140
            set size3   180
            set size4   240
        }
    }

    # Normal fonts
    set ff norm_fontfamilies
    set norm120         [pref_findfont medium r $size1 $ff]
    set norm140         [pref_findfont medium r $size2 $ff]
    set ital140         [pref_findfont medium i $size2 $ff]
    set bold140         [pref_findfont bold   r $size2 $ff]
    set blit140         [pref_findfont bold   i $size2 $ff]
    set norm180         [pref_findfont medium r $size3 $ff]
    set bold180         [pref_findfont bold   r $size3 $ff]
    set norm240         [pref_findfont medium r $size4 $ff]

    # Fixed fonts
    set ff fixed_fontfamilies
    set norm140fixed    [pref_findfont medium r $size2 $ff]
    set bold140fixed    [pref_findfont medium r $size2 $ff]

    # Set option database
    option add *weekdayFont             $norm140 startupFile
    option add *weekendFont             $ital140 startupFile
    option add *interestFont            $bold140 startupFile
    option add *weekendInterestFont     $blit140 startupFile
    option add *itemFont                $norm140 startupFile

    option add *normFont                $norm140 startupFile
    option add *boldFont                $bold140 startupFile
    option add *italFont                $ital140 startupFile

    option add *smallHeadingFont        $bold140 startupFile
    option add *largeHeadingFont        $bold180 startupFile

    option add *normFixedFont           $norm140fixed startupFile
    option add *boldFixedFont           $bold140fixed startupFile

    # General preferences
    option add *Dialog*font             $norm180 startupFile
    option add *Dialog*Message*font     $norm140 startupFile
    option add *Button*font             $bold180 startupFile
    option add *Dayview*Button*font     $bold140 startupFile
    option add *Label*font              $norm180 startupFile
    option add *Menubutton*font         $norm140 startupFile
    option add *Menu*font               $norm140 startupFile
    option add *Listbox*font            $norm140 startupFile
    option add *Text*font               $norm140 startupFile
    option add *Scale*font              $norm140 startupFile

    option add *editkeys*Entry*font     $norm120 startupFile

    # Dialogs with lots of stuff
    option add *Bigdialog*font          $norm140 startupFile
    option add *Bigdialog*Button*font   $bold180 startupFile

    # Date editor preferences
    option add *Dayview*Dateeditor*Label*font   $norm240 startupFile
    option add *Dialog*Dateeditor*Label*font    $norm180 startupFile
    option add *Dialog*Dateeditor*Button*font   $norm180 startupFile
}

# effects - Find font matching given specification
proc pref_findfont {weight style size ff} {
    global preference
    # Try a whole bunch of sizes
    foreach sdelta {0 10 -10 20 -20 30 -30 40 -40} {
        # Search for this size in families
        set s [expr $size + $sdelta]
        foreach family $preference($ff) {
            set f "-*-$family-$weight-$style-normal-*-*-$s-*"
            if [font_exists $f] {
                return $f
            }
        }
    }

    # Return default font
    return fixed
}

# effects - Find first legal color in named list and return it.
proc pref_findcolor {args} {
    foreach c $args {
        if [color_exists $c] {return $c}
    }
    error "could not find any of the following colors: \"[join $args]\""
}

# Methods for obtaining various preferences.

# Return the specified font if it exists, else return fixed.
proc pref_cf {f} {
    if ![font_exists $f] {
        return fixed
    } else {
        return $f
    }
}

proc pref_weekdayFont {} {
    return [pref_cf [option get . weekdayFont Font]]
}

proc pref_weekendFont {} {
    return [pref_cf [option get . weekendFont Font]]
}

proc pref_interestFont {} {
    return [pref_cf [option get . interestFont Font]]
}

proc pref_weekendInterestFont {} {
    return [pref_cf [option get . weekendInterestFont Font]]
}

proc pref_itemFont {} {
    return [pref_cf [option get . itemFont Font]]
}

proc pref_normFont {} {return [pref_cf [option get . normFont Font]]}
proc pref_boldFont {} {return [pref_cf [option get . boldFont Font]]}
proc pref_italFont {} {return [pref_cf [option get . italFont Font]]}

proc pref_smallHeadingFont {} {
    return [pref_cf [option get . smallHeadingFont Font]]
}

proc pref_largeHeadingFont {} {
    return [pref_cf [option get . largeHeadingFont Font]]
}

proc pref_weekdayColor {} {
    return [option get . weekdayColor Foreground]
}

proc pref_weekendColor {} {
    return [option get . weekendColor Foreground]
}

proc pref_interestColor {} {
    return [option get . interestColor Foreground]
}

proc pref_weekendInterestColor {} {
    return [option get . weekendInterestColor Foreground]
}

proc pref_itemFg {} {
    return [option get . itemFg Foreground]
}

proc pref_itemBg {} {
    return [option get . itemBg Background]
}

proc pref_itemSelectFg {} {
    return [option get . itemSelectFg Background]
}

proc pref_itemSelectBg {} {
    return [option get . itemSelectBg Foreground]
}

proc pref_itemSelectWidth {} {
    return [option get . itemSelectWidth Size]
}

proc pref_itemOverflowColor {} {
    return [option get . itemOverflowColor Foreground]
}

proc pref_itemOverflowStipple {} {
    return [option get . itemOverflowStipple Bitmap]
}

proc pref_apptLineColor {} {
    return [option get . apptLineColor Foreground]
}

proc pref_itemPad {} {
    global preference
    return $preference(itemPad)
}

proc pref_pollSeconds {} {
    return [option get . pollSeconds Time]
}

proc pref_saveSeconds {} {
    return [option get . saveSeconds Time]
}
