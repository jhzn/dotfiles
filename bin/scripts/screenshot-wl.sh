#!/bin/bash

#sweet ergonomic wofi-wrapper around grimshot(provided by sway), with the added feature of being able to edit the screenshot in pinta

#prompt user for a decision
function prompt {
	wofi -m -i -p "$1" --show dmenu
}

#where we save screenshots
mkdir -p "$HOME/Pictures/screenshots"


#check if required programs/scripts are available
grimshot_cmd="/usr/share/sway/scripts/grimshot"
if [ ! -x "$grimshot_cmd" ]; then
	grimshot_cmd="/usr/share/sway-git/scripts/grimshot"
	if [ ! -x "$grimshot_cmd" ];then
		echo "grimshot script was not found at the expected paths" && exit 1
	fi
fi
[ ! command -v swappy ] && echo "swappy was not found in \$PATH" && exit 2


grimshot_cmd+=" save"

#using an && chain here so that we can close the wofi windows and just exit out of the script directly
target=$(printf "Current monitor\nActive window\nAll monitors\nSelect area\nSelect window" | prompt "Which target?") && \
save_option=$(printf "Clipboard\nFile" | prompt "Destination?") && \
edit_option=$(printf "No\nYes" | prompt "Edit screenshot?")

tmp_filename="$HOME/Pictures/screenshots/tmp-screenshot.png"

case $target in
	"Active window") grimshot_cmd+=" active";;
	"Current monitor") grimshot_cmd+=" screen";;
	"All monitors") grimshot_cmd+=" output";;
	"Select area") grimshot_cmd+=" area";;
	"Select window") grimshot_cmd+=" window";;
	*) echo "Invalid option" && exit 3;;
esac

final_command="$grimshot_cmd $tmp_filename"
echo "Running command: $final_command"
eval "$final_command"

if [ "$edit_option" = "Yes" ]; then
	swappy --file "$tmp_filename" --output-file "$tmp_filename"
fi

case $save_option in
	"Clipboard")
		cat "$tmp_filename" | wl-copy --type image/png && \
		#clean up
		rm "$tmp_filename" && \
		notify-send "Screenshot" "Copied screenshot to clipboard!"
		;;
	"File")
		file_option=$(printf "Save to $HOME/Pictures/screenshots/\nInput filename" | prompt "File destination?")
		case $file_option in
			"Input filename") filename="$(prompt "File name?")";;
			"Save to $HOME/Pictures/screenshots/") filename="$HOME/Pictures/screenshots/$(date --iso-8601=s).png";;
			*) echo "Invalid option" && exit 4;;
		esac
		mv "$tmp_filename" "$filename" && \
		notify-send "Screenshot" "Saved screenshot to file: $filename!"
		;;
	*) echo "Invalid option" && exit 5;;
esac
