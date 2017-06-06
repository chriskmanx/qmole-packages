#!/bin/bash
herbstclient use Desk
xpause 1 &
_PS=`ps ax | awk '{print $5}' | grep -v grep | grep adie | wc -l`
if [ $_PS -eq 0 ] ; then
  leafpad &
fi



