#!/bin/bash


if [ -n "$WAYLAND_DISPLAY" ]; then
	#using wofi

	##I dont have a custom theme for the powermenu yet
	#rofi_command="wofi --dmenu --columns=5 --height=50 --sort-order=default --cache-file=/dev/null"
	#function logout { swaymsg exit; }
	#function lockscreen { ~/bin/scripts/blurry_swaylock.sh; }

	#or using wlogout
	wlogout -p layer-shell
	exit $?
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
options="$lock\n$logout\n$suspend\n$shutdown\n$reboot\n"

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
		playerctl pause;
		#for X, because xss-lock daemon was running beforehand, the lock screen is automatically started when we run this
		systemctl suspend;
		;;
	$logout)
		logout
		;;
esac

