#!/bin/bash

~/bin/scripts/x_settings.sh

#set background
#this path can for example be a symlink so that we can easily switch our collection of wallpapers
feh -F --bg-fill --randomize ~/Pictures/wallpapers/ || echo "Wallpapers configuration error!"

#Setup polybar
xrandr_output=$(xrandr --query)
primary=$(echo "$xrandr_output" | grep " primary" | cut -d" " -f1)
for monitor in $(echo "$xrandr_output" | grep " connected" | cut -d" " -f1); do

	#Primitive, but seems to work atleast
	#this checks if more than 1 display occupy the same x,y coordinates
	#if so assume they're mirrored
	if [ $(echo "$xrandr_output" | grep "+0+0" | wc -l) -gt 1 ]; then
		echo "Monitor: $monitor is mirrored... setting appropriate polybar"
		MONITOR="$monitor" polybar -c ~/.config/polybar/config bar_prim &
	elif [ "$monitor" == "$primary" ]; then
		echo "Monitor: $monitor is primary... setting appropriate polybar"
		MONITOR="$monitor" polybar -c ~/.config/polybar/config bar_prim &
	else
		echo "Monitor: $monitor is extended... setting appropriate polybar"
		MONITOR="$monitor" polybar -c ~/.config/polybar/config bar_ext &
	fi
done
