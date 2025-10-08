#!/bin/sh

if ping -q -c 1 -W 1 wttr.in >/dev/null; then
    WEATHER=$(curl wttr.in/Moscow?format=3)
    echo $WEATHER
else
    echo "Moscow: ?? ???°C"
fi