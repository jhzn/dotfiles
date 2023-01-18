#!/bin/bash

source ~/.config/dotfiles/bash_strict_mode.sh

~/.config/sway/wallpaper.sh &

# Set previously used monitor layout
# lay populates this file
echo "Running layout recreation"
sleep 3 #necessary to get consistent results
if [[ ! -f "$MONITOR_LAYOUT_FILE" ]]; then
	notify-send "Monitor Layout" "$MONITOR_LAYOUT_FILE file not found"
fi

# Execute the file listed in this file
$(< "$MONITOR_LAYOUT_FILE")

if [ "$?" -eq 0 ]; then
	notify-send "Monitor Layout" "Recreation succeded"
else
	notify-send "Monitor Layout" "Recreation failed"
fi
