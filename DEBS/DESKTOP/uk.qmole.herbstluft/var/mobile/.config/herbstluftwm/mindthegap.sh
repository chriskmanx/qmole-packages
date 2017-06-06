#!/bin/bash

if [ $1 = 0 ]; then
    herbstclient set frame_border_width 0
    herbstclient set window_border_normal_color '#1e1e1e'
    echo 1 > ~/.config/herbstluftwm/dcolor
else
    herbstclient set frame_border_width 1
    herbstclient set window_border_normal_color '#101010'
    echo 2 > ~/.config/herbstluftwm/dcolor
fi

herbstclient set window_border_active_color '#101010'

herbstclient set window_gap "$1"

#herbstclient set snap_gap "$1"
#echo $1 > ~/.config/herbstluftwm/gap
