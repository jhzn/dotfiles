#!/bin/bash -x
set -euo pipefail
shopt -s nullglob globstar

wl_copy_args=("--paste-once --trim-newline")
fzf_opts=("--header 'Password name' --header-first --reverse")

prefix=${PASSWORD_STORE_DIR-~/.password-store}
password_files=( "$prefix"/**/*.gpg )
password_files=( "${password_files[@]#"$prefix"/}" )
password_files=( "${password_files[@]%.gpg}" )

if [[ ! -d "$prefix" ]]; then
	notify-send "Clipboard manager" "No password store found!"
	exit 1
fi

if [[ -d "/usr/share/icons/Papirus" ]]; then
	unlock_icon="--icon=/usr/share/icons/Papirus/32x32/emblems/emblem-unlocked.svg"
	lock_icon="--icon=/usr/share/icons/Papirus/32x32/emblems/emblem-locked.svg"
fi

password=$(printf '%s\n' "${password_files[@]}" | fzfmenu $fzf_opts)

[[ -n $password ]] || exit

password_cleartext=$(pass show "$password")

echo "$password_cleartext" | head -n1 | wl-copy $wl_copy_args
if [[ $? != 0 ]]; then
	notify-send "Clipboard manager" "Some error has occured"
	exit 1
fi

notify-send "$unlock_icon"  "Clipboard manager" "Copied\n$password\n"

#clear n seconds later the password from clipboard manager history
sleep 5

#Yeah this is hard to read
#TODO improve
bash_arg='bash -c '"'echo "'"'"$password_cleartext"'"'"'"

#this here allows us to clear 1 item from the history
clipman clear -t CUSTOM --tool-args "$bash_arg"
notify-send "$lock_icon" "Clipboard manager" "Cleared password from password manager"
