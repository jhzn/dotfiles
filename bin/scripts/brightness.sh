#!/bin/sh

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
