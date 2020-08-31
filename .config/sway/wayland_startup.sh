#!/bin/sh

waybar &
gammastep &
nm-applet --indicator &
udiskie --tray &
lxpolkit &
#clipboard manager
exec wl-paste -t text --watch clipman store 1>> ~/error.log 2>&1 &
#homemade cron
~/bin/scripts/cron.sh &

