#!/bin/bash
DATA=$(hyprctl devices -j | jq -r '.keyboards[] | select(.main == true) | .active_keymap')
DATA="${DATA:0:2}"
echo "${DATA^^}"