#!/bin/bash
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
if ! command -v wtype &> /dev/null; then
	notify-send "Clipboard manager" "'wtype' is not installed!"
	exit 2
fi

if [[ -d "/usr/share/icons/Papirus" ]]; then
	unlock_icon="--icon=/usr/share/icons/Papirus/32x32/emblems/emblem-unlocked.svg"
fi

password=$(printf '%s\n' "${password_files[@]}" | fzfmenu $fzf_opts)

[[ -n $password ]] || exit

password_cleartext="$(pass show "$password" | head --lines=1)"

wtype "$password_cleartext"
notify-send "$unlock_icon"  "Clipboard manager" "Pasted\n$password\n"

