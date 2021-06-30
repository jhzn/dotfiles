#!/bin/sh

~/.config/sway/wallpaper.sh &

#set previously used monitor layout
#lay.sh populates this file
echo "Running layout recreation"
[ -f "$MONITOR_LAYOUT_FILE" ] && sh $(cat "$MONITOR_LAYOUT_FILE")

if [ "$?" -eq 0 ]; then
	echo "Layout recreation succeded"
else
	echo "Layout recreation failed"
fi
