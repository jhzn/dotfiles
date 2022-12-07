#!/bin/bash -x

if ! command -v wtype &> /dev/null; then
	notify-send "Emoji" "'wtype' is not installed!"
	exit 2
fi

SCRIPT=`realpath -s $0`
SCRIPTPATH=`dirname $SCRIPT`

emoji="$(fzfmenu < "$SCRIPTPATH/emojis.txt" | awk '{print $1}')"
wtype "$emoji"
