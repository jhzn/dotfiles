#!/bin/bash

#personal settings
setxkbmap se
#rebind CAPS to an addition escape key
setxkbmap -option caps:escape

#set background
feh -F --bg-fill --randomize ~/Pictures/wallpapers/ || echo "No wallpapers configured"

primary=$(xrandr --query | grep " primary" | cut -d" " -f1)

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
