#!/bin/sh

notify-send "$PRIMARY; $SECONDARY"
if pgrep -u $UID -x sxhkd >/dev/null; then
	pkill -USR1 -x sxhkd
else
	nohup sxhkd &
fi
