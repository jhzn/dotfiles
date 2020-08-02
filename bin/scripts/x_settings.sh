#!/bin/bash

#Fix default X cursor
#details here: https://wiki.archlinux.org/index.php/Cursor_themes#Change_X_shaped_default_cursor
xsetroot -cursor_name left_ptr

#personal settings
setxkbmap se
#rebind CAPS to an addition escape key
setxkbmap -option caps:escape

#setup natural scrolling on touchpad and others
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

