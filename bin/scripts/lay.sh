#!/bin/sh

DIR="$HOME/.screenlayout"
if [ -n "$WAYLAND_DISPLAY" ]; then
	DIR="$HOME/bin/swaylayout"
fi

CHOICE=$(ls "$DIR"  | fzfmenu)
[ -z "$CHOICE" ] && echo "You chose nothing... doing nothing" && exit 1

sh "$DIR/$CHOICE"
notify-send "You chose screenlayout: $CHOICE"

#save layout so that it is started on next login
echo "$DIR/$CHOICE" > "$MONITOR_LAYOUT_FILE"

