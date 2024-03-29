#!/bin/bash

shopt -s nullglob
wallpapers=(~/Pictures/wallpapers/*)
shopt -u nullglob # Turn off nullglob to make sure it doesn't interfere with anything later

wallpapers_count="${#wallpapers[@]}"
[ "$wallpapers_count" -eq 0 ] && echo "No wallpapers found in ~/Pictures/wallpapers. Exiting.." && exit 0


random() {
	echo "${wallpapers[$RANDOM % $wallpapers_count ]}"
}

same() {
	pkill swaybg
	random_wallpaper=$(random)

	echo "Setting wallpaper to: $random_wallpaper for display $display"

	swaybg --image "$random_wallpaper" --mode fill --output '*' &
}

unique() {
	displays=($(swaymsg -t get_outputs -r | jq -r '.[] | select(.active == true) | .name'))

	pkill swaybg

	for display in "${displays[@]}"
	do
		random_wallpaper=$(random)

		echo "Setting wallpaper to: $random_wallpaper for display $display"

		swaybg --image "$random_wallpaper" --mode fill --output "$display" &
	done
}

same
