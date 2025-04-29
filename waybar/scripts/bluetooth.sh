#!/bin/sh

# Get data about bluetooth status
DATA=$(bluetoothctl show | grep Powered | sed -e "s/\tPowered://")

if [ "$DATA" == " no" ]; then
	bluetoothctl power on
else
	bluetoothctl power off
fi

