#!/bin/sh

#start keyring daemon
#https://wiki.archlinux.org/index.php/GNOME/Keyring
# TODO is this optimal? We still need to run 'export $(gnome-keyring-daemon --start)' in our .bashrc
eval $(/usr/bin/gnome-keyring-daemon --daemonize --components=pkcs11,secrets,ssh)
export SSH_AUTH_SOCK

mako &
gammastep-indicator &
nm-applet --indicator &
udiskie --tray --appindicator &
lxpolkit &
#clipboard manager
wl-paste -t text --watch clipman store &
#homemade cron
~/bin/scripts/cron.sh &

autotiling-rs &


~/.config/sway/wallpaper.sh &
