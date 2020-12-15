#!/bin/bash

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Launch Polybar, using default config location ~/.config/polybar/config
#polybar example &

# Launch Polybar for multiple displays
BAR="flush"
#if type "xrandr"; then
#  for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
#    MONITOR=$m polybar --reload $BAR &
#  done
#else
#  polybar --reload flush &
#fi
for m in $(polybar --list-monitors | cut -d":" -f1); do
    MONITOR=$m nohup polybar --reload $BAR &
done

echo "Polybar launched..."
