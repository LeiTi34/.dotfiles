#!/usr/bin/env sh

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

if type "xrandr"; then
  for m in $(xrandr --query | grep " connected [^(]" | cut -d" " -f1); do
    echo $m
    MONITOR=$m polybar --reload xmonad &
    #MONITOR=$m polybar --reload datetime &
    #MONITOR=$m polybar --reload settings &
    #MONITOR=$m polybar --reload ws &
    #MONITOR=$m polybar --reload stats &
  done
else
  polybar --reload xmonad &
  #polybar --reload datetime &
  #polybar --reload settings &
  #polybar --reload ws &
  #polybar --reload stats &
fi

# Launch bar1 and bar2
#polybar bar &
#polybar bar2 &

echo "Bars launched..."
