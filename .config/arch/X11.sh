#!/bin/bash

pacman -S --needed xorg bspwm sxhkd rofi dunst xss-lock xsecurelock \
	xdg-utils xorg-setxkbmap xorg-xinit xf86-input-libinput \
	arandr xclip redshift picom unclutter feh deepin-screenshot wmname

paru -S --needed polybar rofi-greenclip

echo "Setting up custom X11 conf.."

# Hardens X11 a bit
tee /etc/X11/xorg.conf.d/johan.conf <<XORG_CONF
Section "ServerFlags"
	 Option "DontVTSwitch" "True"
	 Option "DontZap"      "True"
EndSection
XORG_CONF
