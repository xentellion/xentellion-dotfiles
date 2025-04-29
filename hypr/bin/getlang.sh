#!/bin/bash
hyprctl devices | grep -A 2 "at-translated-set-2-keyboard" | awk 'NR==3 {print toupper($3)}'| grep -Po '^..(?=.*)'