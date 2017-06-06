#!/bin/bash
herbstclient use Mail
xpause &
_PS=`ps ax | awk '{print $5}' | grep -v grep | grep claws | grep mail | wc -l`
if [ $_PS -eq 0 ] ; then
  claws-mail &
fi



