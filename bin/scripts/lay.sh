#!/bin/sh

CHOICE=$(ls $HOME/.screenlayout | fzf)
[ -z "$CHOICE" ] && echo "You chose nothing... doing nothing" && exit 1

sh "$HOME/.screenlayout/$CHOICE"
notify-send "You chose screenlayout: $CHOICE"

