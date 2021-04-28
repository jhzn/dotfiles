#!/bin/bash

shopt -s nullglob globstar

wl_copy_args=("--paste-once --trim-newline")
wofi_args=("")

usage() {
	echo -e "Wofi based interface for pass

Usage:
wofipassmenu [Options]

Options:
	-h	Help
	-n	Don't use one-time copy (by default copy will be deleted after first paste, but some clients (XWayland) can be break)
	-p	Use the \"primary\" clipboard instead of the regular clipboard
	"
}


while getopts ":hpn" option; do
	echo $option
	case $option in
		h )
			usage
			exit 0
			;;
		n )
			wl_copy_args=("${wl_copy_args[@]/-o}")
			;;
		p )
			wl_copy_args=("${wl_copy_args[@]} -p")
			;;
		\? )
			usage
			exit 1
	esac
done

shift $(expr $OPTIND - 1 )

[[ $1 = "--" ]] && shift
wofi_args=$@
prefix=${PASSWORD_STORE_DIR-~/.password-store}
password_files=( "$prefix"/**/*.gpg )
password_files=( "${password_files[@]#"$prefix"/}" )
password_files=( "${password_files[@]%.gpg}" )

password=$(printf '%s\n' "${password_files[@]}" | wofi -m -i -p "Password name" -O alphabetical --show dmenu $wofi_args)

[[ -n $password ]] || exit

password_cleartext=$(pass show "$password")

echo "$password_cleartext" | head -n1 | wl-copy $wl_copy_args
if [[ $? != 0 ]]; then
	notify-send "Clipboard manager" "Some error has occured"
else
	notify-send "Clipboard manager" "Password\n$password\ncopied to clipboard"

	#clear n seconds later the password from clipboard manager history
	sleep 5

	#Yeah this is hard to read
	#TODO improve
	bash_arg='bash -c '"'echo "'"'"$password_cleartext"'"'"'"

	#this here allows us to clear 1 item from the history
	clipman clear -t CUSTOM --tool-args "$bash_arg" \
		&& notify-send "Clipboard manager" "Cleared password from password manager"
fi
