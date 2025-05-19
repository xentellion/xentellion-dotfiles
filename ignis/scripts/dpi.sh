#!/bin/sh

DATA=$(systemctl is-active zapret)

if [ "$DATA" == "inactive" ]; then
	systemctl start zapret
else
	systemctl stop zapret
fi

echo "$DATA"