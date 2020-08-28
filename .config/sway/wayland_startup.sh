#!/bin/sh

waybar &
gammastep &
nm-applet &
udiskie --tray &
lxpolkit &
#homemade cron
~/bin/scripts/cron.sh &

