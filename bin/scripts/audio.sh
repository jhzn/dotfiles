#!/bin/bash -x

# This script is used as a general audio handling script for volume/play-pause etc.
# It uses existing notification support to display to the end user the status and therefore does not need any additional widget program.
# It only supports wayland atm, with mako as the notification daemon

# Depends on https://github.com/vlevit/notify-send.sh being available in PATH

#we have to do some additional work because mako does not support using "notify-send" with "hints" that is, with "-h" flag.
#we therefore have to use notify-send.sh which adds support for outputting notification ID and replacing current notifications
notifiy () {
	subject="$3"
	p=/tmp/audio_notification_"$subject"

	#check if we have any currently active notfications which has the subject
	current_notifications=$(makoctl list | jq '.data[]' | grep -i "$subject")
	if [ ! "$current_notifications" ]; then
		#truncate file because the data is old
		> "$p"
	fi

	prev_ID=$(<"$p")
	if [ -z "$prev_ID" ]; then
		ID=$(notify-send.sh --print-id "$1" "$2")
		echo -n "$ID" > "$p"
	else
		ID=$(notify-send.sh --replace="$prev_ID" "$1" "$2")
	fi
}

current_volume () {
	echo $(pulsemixer --get-volume | awk '{ print $1 }')
}

case $1 in
	up) pulsemixer --change-volume +5 && notifiy "Audio change" "Volume: $(current_volume) %" "volume";;

	down ) pulsemixer --change-volume -5 && notifiy "Audio change" "Volume: $(current_volume) %" "volume";;

	mute-toggle ) pulsemixer --toggle
		if [ $(pulsemixer --get-mute) -eq 0 ]; then
			notifiy "Audio change" "Unmute" "mute"
		else
			notifiy "Audio change" "Mute" "mute"
		fi
	;;

	play-pause ) playerctl play-pause && notifiy "Player change" "Play-Pause" "pause";;

	next ) playerctl next && notifiy "Player change" "Next" "player";;

	previous ) playerctl previous && notifiy "Player change" "Previous" "player";;

#  *) echo -n "an unknown number of";;
esac
