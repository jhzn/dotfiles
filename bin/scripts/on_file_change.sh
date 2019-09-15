#!/bin/bash

#if more arguments are passed than a script path then those arguments are then taken as files which the subsequent script is only to be applied to
#example ./this_script.sh some_random_echo_script.sh $filename
#$filename refers to the local variable of the file that has been changed
#This would mean that some_random_echo_script.sh would only execute if the file that was changed was $filename

[ -z $1 ] && echo "Missing first arg which is the script to run whenever a file has been changed" && exit 1

#This is the script which is be run whenever a file has been changed
SCRIPT_TO_RUN=$1
[ ! -x "$SCRIPT_TO_RUN" ] && echo "'$SCRIPT_TO_RUN' file is not executable. Try chmod +x" && exit 1

#Default input to the $SCRIPT_TO_RUN
SCRIPT_TO_RUN_ARGS="${@:2}"

inotifywait -e close_write,moved_to,create -m -r . |
while read -r directory events filename; do
	if [[ -z "$SCRIPT_TO_RUN_ARGS" ]]; then
		bash $SCRIPT_TO_RUN "$filename"
	elif [[ "$SCRIPT_TO_RUN_ARGS" =~ "$filename" ]]; then
		bash $SCRIPT_TO_RUN "$filename"
	fi
done
