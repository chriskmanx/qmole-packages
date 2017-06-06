#!/bin/bash
herbstclient use Web
xpause 4 &
_PS=`ps ax | awk '{print $5}' | grep -v grep | grep netsurf | wc -l`
if [ $_PS -eq 0 ] ; then
    if [ $(which netsurf) ]; then
	netsurf &
    else
	qmole-msg "NETSURF IS NOT INSTALLED. PLEASE DOWNLOAD!"
    fi
fi



