#!/bin/sh

~/.config/sway/wallpaper.sh &

#set previously used monitor layout
#lay.sh populates this file
[ -f /tmp/monitorlayout ] && sh $(cat /tmp/monitorlayout)
