# Copyright (C) 2005 Ethan Blanton <elb@elitists.net>
# Version 1.0

proc bind_icon_window { view } {
    upvar "::_iw_${view}" iw
    set iw(win) [toplevel [$view window]_iwin]
    set iw(c) [canvas $iw(win).c -width 48 -height 48]
    $iw(c) create rectangle 6 6 48 48 -outline darkgrey -fill darkgrey
    $iw(c) create rectangle 1 1 44 44 -fill white
    $iw(c) create oval 15 4 19 8 -fill black
    $iw(c) create oval 25 4 29 8 -fill black
    set iw(mfont) [font create -family Arial -size 10 -weight bold]
    set iw(dfont) [font create -family Arial -size 16]
    set iw(month) [$iw(c) create text 22 36 \
                          -text [clock format [clock seconds] -format "%b"] \
                          -font $iw(mfont)]
    set iw(day) [$iw(c) create text 22 20 \
                        -text [date monthday [date today]] \
                        -font $iw(dfont)]
    pack $iw(c)
    wm iconwindow [$view window] $iw(win)
    trigger on midnight [list update_icon_window $view]
}

proc delete_icon_window { view } {
    upvar "::_iw_${view}" iw
    destroy $iw(win)
    font delete $iw(mfont)
    font delete $iw(dfont)
    trigger remove midnight [list update_icon_window $view]
    unset iw
}

proc update_icon_window { view } {
    upvar "::_iw_${view}" iw
    $iw(c) itemconfigure $iw(month) -text [clock format [clock seconds] \
                                    -format "%b"]
    $iw(c) itemconfigure $iw(day) -text [date monthday [date today]]
}

append-hook dayview-startup { view } { bind_icon_window $view }
append-hook dayview-close { view } { delete_icon_window $view }
