#!/bin/bash


if [ -n "$WAYLAND_DISPLAY" ]; then
	#I dont have a custom theme for the powermenu yet
	rofi_command="wofi --dmenu --columns=5 --height=50"
	function logout { swaymsg exit; }
	function lockscreen { swaylock; }
else
	rofi_command="rofi -theme ~/.config/rofi/themes/powermenu.rasi -monitor primary -dmenu -selected-row 2"
	function logout { bspc quit; }
	function lockscreen { xsecurelock; }
fi


uptime=$(uptime -p | sed -e 's/up //g')
# Options
shutdown="Shutdown 襤"
reboot="Reboot ﰇ"
lock="Lock "
suspend="Suspend 鈴"
logout="Logout "

# Variable passed to rofi
options="$shutdown\n$reboot\n$lock\n$suspend\n$logout"

chosen="$(echo -e "$options" | $rofi_command -p "UP - $uptime" )"

case $chosen in
	$shutdown)
		systemctl poweroff
		;;
	$reboot)
		systemctl reboot
		;;
	$lock)
		playerctl pause;
		lockscreen
		;;
	$suspend)
		playerctl play-pause;
		#for X, because xss-lock daemon was running beforehand, the lock screen is automatically started when we run this
		systemctl suspend;
		;;
	$logout)
		logout
		;;
esac

