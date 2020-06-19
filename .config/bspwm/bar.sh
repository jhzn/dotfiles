#!/bin/bash

#set background
feh -F --bg-fill --randomize ~/Pictures/wallpapers/ || echo "No wallpapers configured"

primary=$(xrandr --query | grep " primary" | cut -d" " -f1)

#run | lemonbar -p &
for monitor in $(xrandr --query | grep " connected" | cut -d" " -f1); do
	echo "$monitor|$primary" >> ~/error.log
	if [ "$monitor" == "$primary" ]; then
		echo "primary">> ~/error.log
		MONITOR="$monitor" polybar -c ~/.config/polybar/config bar_prim &
	else
		echo "ext">> ~/error.log
		MONITOR="$monitor" polybar -c ~/.config/polybar/config bar_ext &
	fi
done
