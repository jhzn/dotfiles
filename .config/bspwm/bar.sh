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
