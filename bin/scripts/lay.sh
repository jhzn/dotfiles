#!/bin/sh

DIR="$HOME/.screenlayout"
if [ -n "$WAYLAND_DISPLAY" ]; then
	DIR="$HOME/bin/swaylayout"
fi

CHOICE=$(ls "$DIR"  | fzf)
[ -z "$CHOICE" ] && echo "You chose nothing... doing nothing" && exit 1

sh "$DIR/$CHOICE"
notify-send "You chose screenlayout: $CHOICE"

