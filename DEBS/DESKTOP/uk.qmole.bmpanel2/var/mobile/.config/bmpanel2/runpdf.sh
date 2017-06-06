#!/bin/bash
herbstclient use Pdf
xpause &
_PS=`ps ax | awk '{print $5}' | grep -v grep | grep xournal | wc -l`
if [ $_PS -eq 0 ] ; then
  xournal &
fi




