#!/bin/sh

#start keyring daemon
#https://wiki.archlinux.org/index.php/GNOME/Keyring
# TODO is this optimal? We still need to run 'export $(gnome-keyring-daemon --start)' in our .bashrc
eval $(/usr/bin/gnome-keyring-daemon --daemonize --components=pkcs11,secrets,ssh)
export SSH_AUTH_SOCK

waybar &
gammastep &
nm-applet --indicator &
udiskie --tray &
lxpolkit &
#clipboard manager
exec wl-paste -t text --watch clipman store 1>> ~/error.log 2>&1 &
#homemade cron
~/bin/scripts/cron.sh &

