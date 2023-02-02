#!/bin/bash

if ! command -v wtype &> /dev/null; then
	notify-send "Emoji" "'wtype' is not installed!"
	exit 2
fi

SCRIPT=`realpath -s $0`
SCRIPTPATH=`dirname $SCRIPT`

emoji="$(fzfmenu < "$SCRIPTPATH/emojis.txt" | awk '{print $1}')"

# Because chromium browsers suck, we can't use wtype on them, so copy to clipboard as a workaround
focused_window=$(swaymsg -t get_tree | jq -r '.. | select(.type?) | select(.focused==true).app_id')
browsers=("brave-browser" "chromium" "google-chrome")
if [[ "${browsers[*]}"  =~ "$focused_window" ]]; then
	echo "$emoji" | wl-copy
	notify-send "Clipboard" "Copied $emoji"
else
	wtype "$emoji"
fi
