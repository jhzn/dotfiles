#!/bin/bash

#if more arguments are passed than a script path then those arguments are then taken as files which the subsequent script is only to be applied to
#example ./this_script.sh some_random_echo_script.sh $filename
#$filename refers to the local variable of the file that has been changed
#This would mean that some_random_echo_script.sh would only execute if the file that was changed was $filename

[ -z $1 ] && echo "Missing first arg which is the script to run whenever a file has been changed" && exit 1

#This is the script which is be run whenever a file has been changed
SCRIPT_PARAM=$1

inotifywait -e close_write,moved_to,create -m -r . |
while read -r directory events filename; do
	if [[ -z ${@:2} ]]; then
		$SCRIPT_PARAM "$filename"
	elif [[ "${@:2}" =~ "$filename" ]]; then
		echo "BANAN"
		$SCRIPT_PARAM "$filename"
	fi
done
