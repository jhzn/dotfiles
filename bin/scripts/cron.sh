#!/bin/sh

#Home made crontab good enough

while true; do
#	echo "Running cron iteration"

	~/bin/scripts/battery_notification.sh

	sleep 60
done
