#!/bin/bash

#start keyring daemon
#https://wiki.archlinux.org/index.php/GNOME/Keyring
# TODO is this optimal? We still need to run 'export $(gnome-keyring-daemon --start)' in our .bashrc
eval $(/usr/bin/gnome-keyring-daemon --daemonize --components=pkcs11,secrets,ssh)
export SSH_AUTH_SOCK

mako &
~/.config/sway/wlsunset-toggle.sh &
nm-applet --indicator &
udiskie --tray --appindicator &
lxpolkit &
#clipboard manager
wl-paste -t text --watch clipman store --max-items=30 &
#homemade cron
~/bin/scripts/cron.sh &
[[ $(which kdeconnect-indicator) ]] && kdeconnect-indicator &


#inactive windows are more transparent than focuses on
inactive-windows-transparency.py &

autotiling-rs &
