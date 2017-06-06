#!/bin/bash
herbstclient use Desk
_PS=`ps ax | awk '{print $5}' | grep -v grep | grep xmaxima | wc -l`
if [ $_PS -eq 0 ] ; then
  xmaxima &
fi



