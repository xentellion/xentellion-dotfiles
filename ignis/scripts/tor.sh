#!/bin/sh

DATA=$(torctl status | grep "torctl is" | grep -oE '[^[:space:]]+$')

if [ "$DATA" == "started" ]; then
	torctl stop
else
	torctl start
fi

echo "$DATA"