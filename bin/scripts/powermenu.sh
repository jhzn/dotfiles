#!/bin/bash
#
# a simple dmenu session script
#
###

#DMENU='dmenu -i -b -fn -xos4-terminus-medium-r-*--12-*-*-*-*-*-iso10646-1 -nb #000000 -nf #999999 -sb #000000 -sf #31658C'
DMENU='dmenu'
choice=$(echo -e "lock\nlogout\nshutdown\nreboot\nsuspend\nhibernate" | $DMENU)

case "$choice" in
  lock) xscreensaver-command -lock & ;;
  logout) bspc quit & ;;
  shutdown) shutdown -h now & ;;
  reboot) shutdown -r now & ;;
  suspend) pm-suspend & ;;
  hibernate) pm-hibernate & ;;
esac
