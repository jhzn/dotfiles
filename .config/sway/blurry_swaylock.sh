#!/bin/bash

#inspiration from https://gitlab.com/rigopoui/dotfiles-and-themes/-/raw/master/laptop/.local/bin/lock
#this creates a blurry screenshot and uses that image when locking the screen as the lockscreen wallpaper

TMPBG=/tmp/screen.png
#subshell gets the focused monitor, this is used so that we dont have to hardcode any monitors here
grim -o $(swaymsg -p -t get_outputs | grep focused | awk '{print $2}') /tmp/screen.png

convert "$TMPBG" -scale 2% -resize 1000% "$TMPBG"
convert $TMPBG -gravity south \
	-font '/usr/share/fonts/TTF/JetBrains Mono Regular Nerd Font Complete Mono.ttf' \
	-pointsize 100 -fill white -draw 'text 0,200 ""' "$TMPBG"

PARAM=(-e -K --inside-color=262626ff --ring-color=f0f0f0ff --line-uses-inside \
	--key-hl-color=ff6e67ff --bs-hl-color=ff6e67ff --separator-color=00000000 \
	--inside-ver-color=262626ff --inside-wrong-color=a11a14ff --inside-clear-color=262626ff \
	--ring-clear-color=f0f0f0ff
	--ring-ver-color=f0f0f0ff --ring-wrong-color=f0f0f0ff \
	--indicator-radius=50 --indicator-thickness=10 --text-wrong-color=00000000 \
	--text-ver-color=00000000 --text-color=00000000 --text-clear-color=00000000)
swaylock "${PARAM[@]}" -f -c 000000 -i "$TMPBG";
