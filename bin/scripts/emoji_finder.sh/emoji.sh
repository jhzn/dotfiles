#!/bin/bash

if [ -z "$1" ]; then
	echo "Missing 1st argument as search term. Use --help for more info"
	exit 1
fi

if [ "$1" == '--help' ]; then
	printf "This is a program to find emojis and select to clipboard.\n\nTry inputing 'banana' as 1st argument\n"
	exit 0
fi

# get matches
emoji_matches=(`cat ./emojis.txt | grep -i "$1" | awk '{print $1}'`)

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

# copy user chosen emoji to clipboard
echo "Copied emoji($answer) to clipboard!"
printf "$answer" | xclip -sel clip
exit 0