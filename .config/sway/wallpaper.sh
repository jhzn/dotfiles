#!/bin/bash

shopt -s nullglob
wallpapers=(~/Pictures/wallpapers/*)
shopt -u nullglob # Turn off nullglob to make sure it doesn't interfere with anything later

wallpapers_count="${#wallpapers[@]}"
[ "$wallpapers_count" -eq 0 ] && echo "No wallpapers found in ~/Pictures/wallpapers. Exiting.." && exit 0

random_wallpaper=${wallpapers[$RANDOM % $wallpapers_count ]}

echo "Setting wallpaper to: $random_wallpaper"

pkill swaybg
swaybg --image "$random_wallpaper" --mode fill --output "*" &

