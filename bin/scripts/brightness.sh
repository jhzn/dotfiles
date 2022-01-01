#!/bin/bash -x

source ~/.config/dotfiles/bash_strict_mode.sh

backend="laptop"
if [[ $(command -v ddcutil detect) ]]; then
	backend="ddcutil"
fi

if [[ "$backend" == "laptop" ]]; then
	#just a minor wrapper around brightnessctl to reach 1% when we hit 5% and want to decrease brightness further down

	#TODO fix inefficiency
	current_level=$(brightnessctl | grep Current | awk '{print $4}' | sed -e 's/(//' -e 's/)//' -e 's/%//')
	increment=5

	case "$1" in
		up)
			[ "$current_level" -eq 1 ] && increment=4
			brightnessctl set +"$increment"%;;
		down )
			[ "$current_level" -eq 5 ] && increment=4
			brightnessctl set "$increment"%-;;
	esac
fi

if [[ "$backend" == "ddcutil" ]]; then
	displays=$(ddcutil detect | grep Display | awk '{print $2}')

	# just get for 1 display, not pretty but simple
	current_level=$(ddcutil --display=1 -t getvcp 10 | awk '{print $4}')
	increment=10
	case "$1" in
		up)
			# brightnessctl set +"$increment"%;;
			new_level=$(( $current_level + $increment));;
		down )
			new_level=$(( $current_level - $increment));;
	esac

	# Protection against hitting above/below boundries
	if (( "$new_level" >= 100 )); then
		new_level=100
	fi
	if (( "$new_level" <= 10 )); then
		new_level=10
	fi

	for d in $displays;do
		ddcutil --display="$d" setvcp 10 "$new_level"
	done
fi
