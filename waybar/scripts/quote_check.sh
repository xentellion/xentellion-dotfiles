#!/bin/sh
TEXT=$(hyprctl activewindow -j | grep title | awk -F ' ' '{print $2}')
if [ $TEXT == '""' ]; then
    echo 0
else
    echo 1
fi