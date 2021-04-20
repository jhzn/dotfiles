#!/bin/bash

#If we dont have a battery, quit
[ ! -d /sys/class/power_supply/BAT0 ] && exit 0

function notify() {
	readonly TIME="$1"
	readonly MSG="$2"
	[ -z "$MSG" ] && MSG="Your battery is running low!"
	notify-send --urgency=critical --expire-time="$TIME" "$MSG At $BAT_PROC%"
}

readonly BAT_PROC=$(cat /sys/class/power_supply/BAT0/capacity)
readonly BAT_STATUS=$(cat /sys/class/power_supply/BAT0/status)

#if charging, we've solved the issue :)
[ "$BAT_STATUS" == "Charging" ] && exit 0
[ "$BAT_STATUS" == "Full" ] && exit 0

[ "$BAT_PROC" -le 15 ] && notify 10000
[ "$BAT_PROC" -le 10 ] && notify 10000
#Make the notification permanent
[ "$BAT_PROC" -le 5 ] && notify 0 "Battery Low! You are running out of time! Hurry!"
