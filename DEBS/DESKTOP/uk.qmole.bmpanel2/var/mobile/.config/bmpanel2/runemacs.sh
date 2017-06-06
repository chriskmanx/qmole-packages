#!/bin/bash
herbstclient use Edit
xpause 6 &
_PS=`ps ax | awk '{print $5}' | grep -v grep | grep emacs | wc -l`
if [ $_PS -eq 0 ] ; then
    if [ $(which emacs) ]; then
	emacs &
    else
	qmole-msg "EMACS IS NOT INSTALLED. PLEASE DOWNLOAD!"
    fi
fi


