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
		playerctl play-pause;
		xsecurelock
		;;
	$suspend)
		playerctl play-pause;
		#pulsemixer --toggle-mute;
		#because xss-lock daemon was running beforehand, the lock screen is automatically started when we run this
		systemctl suspend;
		;;
	$logout)
		bspc quit
		;;
esac

