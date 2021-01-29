#!/bin/bash

if [ -z "$1" ]; then
	echo "This is a program to find emojis and select them to the clipboard"
	echo "Try inputing 'banana' as 1st argument"
	echo "Or use the flag --print-all to output the document which searches as applied to"
	exit 1
fi

SCRIPT=`realpath -s $0`
SCRIPTPATH=`dirname $SCRIPT`

if [ "$1" == "--print-all" ]; then
	cat "$SCRIPTPATH/emojis.txt"
	exit 0
fi

# get matches
emoji_matches=($(grep -i "$1" "$SCRIPTPATH/emojis.txt" | awk '{print $1}'))
if [ ${#emoji_matches[@]} == 0 ]; then
	echo "No matches were found"
	exit 0
fi

PS3='Please enter your choice: '
# give user selection prompt of matches
select answer in "${emoji_matches[@]}"; do
	for item in "${emoji_matches[@]}"; do
		if [[ $item == $answer ]]; then
			break 2
		fi
	done
done

copy_command="xclip -sel clip"
if [ -n "$WAYLAND_DISPLAY" ]; then
	copy_command="wl-copy --trim-newline"
fi

# copy user chosen emoji to clipboard
echo "Copied emoji($answer) to clipboard!"
printf "$answer" | eval "$copy_command"
exit 0
