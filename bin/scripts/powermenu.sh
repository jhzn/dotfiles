#!/bin/bash

rofi_command="rofi -theme ~/.config/rofi/themes/powermenu.rasi"
uptime=$(uptime -p | sed -e 's/up //g')
# Options
shutdown="Shutdown 襤"
reboot="Reboot ﰇ"
lock="Lock "
suspend="Suspend 鈴"
logout="Logout "

# Variable passed to rofi
options="$shutdown\n$reboot\n$lock\n$suspend\n$logout"

chosen="$(echo -e "$options" | $rofi_command -p "UP - $uptime" -dmenu -selected-row 2)"

case $chosen in
	$shutdown)
		systemctl poweroff
		;;
	$reboot)
		systemctl reboot
		;;
	$lock)
		xscreensaver-command -lock
		;;
	$suspend)
		playerctl play-pause;
		#pulsemixer --toggle-mute;
		systemctl suspend;
		;;
	$logout)
		bspc quit
		;;
esac

