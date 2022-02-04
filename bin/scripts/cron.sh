#!/bin/sh

#Home made crontab good enough :=)

while true; do
	~/bin/scripts/battery_notification.sh
	sleep 120
done &


while true; do
	~/.config/sway/wallpaper.sh
	sleep 3600
done &
