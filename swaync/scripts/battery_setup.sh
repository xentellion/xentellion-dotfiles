#!/bin/bash
chmod +x ./swaync/scripts/battery
chmod +x ./swaync/scripts/charge_notify

cp ./swaync/scripts/charge_notify /etc/pm/power.d/charge_notify

# crontab
"*/1 * * * * /home/<username>/.config/swaync/scripts/battery"