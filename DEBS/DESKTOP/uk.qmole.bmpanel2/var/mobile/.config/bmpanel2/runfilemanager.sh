#!/bin/bash
herbstclient use File
xpause &
_PS=`ps ax | awk '{print $5}' | grep -v grep | grep Filer | grep ROX | wc -l`
if [ $_PS -eq 0 ] ; then
  /usr/local/bin/roxfiler &
fi



