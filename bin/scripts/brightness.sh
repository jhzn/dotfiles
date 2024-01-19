#!/bin/bash

arg="$1"
source ~/.config/dotfiles/bash_strict_mode.sh

# A wrapper around brightnessctl to reach 1% when we hit 5% and want to decrease brightness further down
# Also able to control regular monitors.

laptop_monitor() {
	# if [[ -n "$1" ]] && (( "$1" > 0 && "$1" <= 100 )); then
		# brightnessctl set "$1"%
		# return
	# fi

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
}

regular_monitor() {
	set_monitors() {
		displays=$(ddcutil detect | grep Display | awk '{print $2}')
		for d in $displays; do
			ddcutil --display="$d" setvcp 10 "$1"
			echo "Setting display $d to brightness of $1% with ddcutil"
		done
	}

	# If we're connected to monitors, go faster, ddcutil is slow
	increment=10

	# just get for 1 display, not pretty but simple
	current_level=$(ddcutil --display=1 -t getvcp 10 | tail -n1 | awk '{print $4}')
	case "$1" in
		up)
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

	set_monitors "$new_level"
}


# Laptops have batteries.
if [[ -d /sys/class/power_supply/BAT0 ]]; then
	laptop_monitor "$arg"
	# Make this the script faster by exiting if we only have 1 monitor and it's a laptop one.
	if [[ $(swaymsg -t get_outputs -p | grep Output | wc -l) -eq 1 ]]; then
		exit 0
	fi
fi

if [[ $(command -v ddcutil detect) ]]; then
	regular_monitor "$arg"
fi
