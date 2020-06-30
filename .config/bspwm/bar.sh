#!/bin/bash

#personal settings
setxkbmap se
#rebind CAPS to an addition escape key
setxkbmap -option caps:escape

#setup natural scrolling on touchpad
#1st: run and find identifier of touchpad using xinput --list
#check current value with: xinput --list-props
#plug touchpad identifier below
function set_touch_pad_options {
	xinput set-prop "$1" "libinput Natural Scrolling Enabled" 1; \
	xinput set-prop "$1" "libinput Tapping Enabled" 1; \
	xinput set-prop "$1" "libinput Click Method Enabled" 0 1
}
[ "$(hostname)" == 'johan-laptop' ] && \
	set_touch_pad_options 'SynPS/2 Synaptics TouchPad'
[ "$(hostname)" == 'johan-XPS' ] && \
	set_touch_pad_options 'DLL07BE:01 06CB:7A13 Touchpad'

#set background
feh -F --bg-fill --randomize ~/Pictures/wallpapers/ || echo "Wallpapers configuration error!"

primary=$(xrandr --query | grep " primary" | cut -d" " -f1)

xrandr_output=$(xrandr --query)
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
