#!/bin/sh

export PRIMARY
export SECONDARY
notify-send "$PRIMARY; $SECONDARY"

pkill sxhkd
nohup sxhkd &

# code below restarts sxhkd
#if pgrep -u $UID -x sxhkd >/dev/null; then
#	pkill -USR1 -x sxhkd
#else
#	nohup sxhkd &
#fi
