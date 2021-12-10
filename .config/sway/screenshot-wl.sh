#!/bin/bash

#sweet ergonomic wofi-wrapper around grimshot(provided by sway), with the added feature of being able to edit the screenshot in swappy
set -euo pipefail
#prompt user for a decision
function prompt {
	wofi -m -i -p "$1" --show dmenu
}

# String Util func
function join_by { local d=${1-} f=${2-}; if shift 2; then printf %s "$f" "${@/#/$d}"; fi; }

screenshot_dir="$HOME/Pictures/screenshots"
#where we save screenshots
mkdir -p "$screenshot_dir"


#check if required programs/scripts are available
grimshot_cmd="grimshot"
[ ! -x "$(command -v $grimshot_cmd)" ] && echo "grimshot script was not found in \$PATH " && exit 1
[ ! -x "$(command -v swappy)" ] && echo "swappy was not found in \$PATH" && exit 2

grimshot_cmd+=" save"

opt1="Current window"
opt2="Current monitor"
opt3="All monitors"
opt4="Select area"
opt5="Select window"
opt6="Select area(timer 5 sec)"

target=$(printf "$(join_by  $'\n' "$opt1" "$opt2" "$opt3" "$opt4" "$opt5" "$opt6")"  | prompt "Which target?")
save_option=$(printf "Clipboard\nFile" | prompt "Destination?")
edit_option=$(printf "No\nYes" | prompt "Edit screenshot?")

tmp_filename="$screenshot_dir/tmp-screenshot.png"

case $target in
	"$opt1") grimshot_cmd+=" active";;
	"$opt2") grimshot_cmd+=" output";;
	"$opt3") grimshot_cmd+=" screen";;
	"$opt4") grimshot_cmd+=" area";;
	"$opt5") grimshot_cmd+=" window";;
	"$opt6") grimshot_cmd+=" area"; sleep 5;;
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
		file_option=$(printf "Save to $screenshot_dir/\nInput filename" | prompt "File destination?")
		case $file_option in
			"Input filename") filename="$(prompt "File name?")";;
			"Save to $screenshot_dir/") filename="$screenshot_dir/$(date --iso-8601=s).png";;
			*) echo "Invalid option" && exit 4;;
		esac
		mv "$tmp_filename" "$filename" && \
		notify-send "Screenshot" "Saved screenshot to file: $filename!"
		;;
	*) echo "Invalid option" && exit 5;;
esac
