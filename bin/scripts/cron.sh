#!/bin/sh

#Home made crontab good enough :=)

minute=60
hour=$(($minute*60))

while true; do
	~/bin/scripts/battery_notification.sh
	sleep $(($minute*2))
done &


while true; do
	~/.config/sway/wallpaper.sh
	sleep $hour
done &
