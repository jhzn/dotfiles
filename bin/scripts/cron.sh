#!/bin/bash -x
#
# Bash strict mode
set -euo pipefail
# Neat way to show the line and program which caused the error in a pipeline
trap 's=$?; echo >&2 "$0: Error on line "$LINENO": $BASH_COMMAND"; exit $s' ERR

#Home made crontab good enough :=)

minute=60
hour=$(($minute*60))

while true; do
	~/bin/scripts/battery_notification.sh
	sleep $(($minute*2))
done &


while true; do
	~/.config/sway/wallpaper.sh
	~/bin/scripts/backuper.sh
	sleep $hour
done &
