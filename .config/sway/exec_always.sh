#!/bin/sh

~/.config/sway/wallpaper.sh &

#set previously used monitor layout
#lay.sh populates this file
[ -f "$MONITOR_LAYOUT_FILE" ] && sh $(cat "$MONITOR_LAYOUT_FILE")
