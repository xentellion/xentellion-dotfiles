#!/bin/sh

DATA=$(nmcli networking)

if [ "$DATA" == "enabled" ]; then
	nmcli networking off
else
	nmcli networking on
	rfkill unblock 0
fi

echo $DATA