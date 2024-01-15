#!/bin/bash

# This is sweet ergonomic GUI-wrapper around grimshot(provided by sway), with the added feature of being able to edit the screenshot in swappy

source ~/.config/dotfiles/bash_strict_mode.sh

trim() {
	local var="$*"
	# remove leading whitespace characters
	var="${var#"${var%%[![:space:]]*}"}"
	# remove trailing whitespace characters
	var="${var%"${var##*[![:space:]]}"}"
	printf '%s' "$var"
}
prompt() {
	title="$1"
	choices="${@:2}"
	choice=$(printf "$choices" | fzfmenu --header \'"$1"\' --header-first --reverse --print-query)
	if [[ "$choice" == "" ]]; then
		exit 1
	fi
	printf "$(trim $choice)"
}

# String Util func
function join_by { local d=${1-} f=${2-}; if shift 2; then printf %s "$f" "${@/#/$d}"; fi; }

screenshot_dir="$HOME/Pictures/screenshots"
#where we save screenshots
mkdir -p "$screenshot_dir"


#check if required programs/scripts are available
cmd="grimshot"
[ ! -x "$(command -v $cmd)" ] && echo "grimshot script was not found in \$PATH " && exit 1
[ ! -x "$(command -v swappy)" ] && echo "swappy was not found in \$PATH" && exit 2


opt1="Current window"
opt2="Current monitor"
opt3="All monitors"
opt4="Select area"
opt5="Select window"

opts=$(join_by  $'\n' "$opt1" "$opt2" "$opt3" "$opt4" "$opt5")
target=$(prompt "Which target?" "$opts")

cmd+=" save"
case $target in
	"$opt1") cmd+=" active";;
	"$opt2") cmd+=" output";;
	"$opt3") cmd+=" screen";;
	"$opt4") cmd+=" area";;
	"$opt5") cmd+=" window";;
	*) echo "Invalid option" && exit 3;;
esac

save_option=$(prompt "Destination?" "Clipboard\nFile")
edit_option=$(prompt "Edit screenshot?" "No\nYes")
delay_option=$(prompt "Delay of 5 seconds" "No\nYes")
if [ "$delay_option" = "Yes" ]; then
	swaymsg "focus_follows_mouse no"
	echo "$cmd"
	sleep='notify-send --expire-time=3000 "Screenshot" "Taking in 5 seconds" && sleep 5'
	if [[ "$cmd" == "grimshot save area" ]]; then
		cmd='slurp=$(slurp) && '"$sleep"' && grim -g "$slurp"'
	else
		cmd="$sleep && $cmd"
	fi
fi

tmp_filename="$screenshot_dir/tmp-screenshot.png"

final_command="$cmd $tmp_filename"
echo "Running command: $final_command"

disable_focus_flasher="/tmp/disable_focus_flasher"
touch "$disable_focus_flasher"

function cleanup {
	rm "$disable_focus_flasher"
}
trap cleanup EXIT
# Run the command
eval "$final_command"

swaymsg "focus_follows_mouse yes"

if [ "$edit_option" = "Yes" ]; then
	swappy --file "$tmp_filename" --output-file "$tmp_filename"
fi

case $save_option in
	"Clipboard")
		wl-copy --type image/png < "$tmp_filename"
		#clean up
		rm "$tmp_filename"
		notify-send "Screenshot" "Copied screenshot to clipboard!"
		;;
	"File")
		file_option=$(prompt "File destination?" "Save to $screenshot_dir/\nInput filename")
		case $file_option in
			"Input filename") filename="$(prompt "File name?")";;
			"Save to $screenshot_dir/") filename="$screenshot_dir/$(date --iso-8601=s).png";;
			*) echo "Invalid option" && exit 4;;
		esac
		mv "$tmp_filename" "$filename"
		notify-send "Screenshot" "Saved screenshot to file: $filename!"
		;;
	*) echo "Invalid option" && exit 5;;
esac
