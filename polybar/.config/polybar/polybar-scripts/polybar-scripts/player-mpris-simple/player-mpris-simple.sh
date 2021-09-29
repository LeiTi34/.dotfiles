#!/bin/sh

ignore=''

while read p; do
    case "$p" in
        "chromium.instance"*) ignore="$ignore -i $p";;
    esac
done <<< $(playerctl -l 2> /dev/null)

player_status=$(playerctl status $ignore 2> /dev/null)

if [ "$player_status" = "Playing" ]; then
    echo " $(playerctl metadata artist $ignore 2> /dev/null) - $(playerctl metadata title $ignore 2> /dev/null)" | cut -c1-50
#elif [ "$player_status" = "Paused" ]; then
#    echo " $(playerctl metadata artist $ignore 2> /dev/null) - $(playerctl metadata title $ignore 2> /dev/null)" | cut -c1-50
else
    echo ""
fi
