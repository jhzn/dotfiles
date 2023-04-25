#!/bin/bash -x
#
source ~/.config/dotfiles/bash_strict_mode.sh

# Options
shutdown="Shutdown 襤"
reboot="Reboot ﰇ"
lock="Lock "
suspend="Suspend 鈴"
logout="Logout "

options="$lock\n$logout\n$suspend\n$shutdown\n$reboot\n"

uptime=$(uptime -p | sed -e 's/up //g')
menu_text=$(printf "'Power menu\n----------------------\nUptime: %s'" "$uptime")

export PICKER_CLASS='powermenu'
choice=$(echo -e "$options" | fzfmenu "--no-multi --cycle --header $menu_text")

if [[ "$(timew | grep Started)" ]]; then
	notify-send "Powermenu" "Timewarrior is tracking. Aborting"
	exit 1
fi

case $choice in
	$shutdown)
		systemctl poweroff
		;;
	$reboot)
		systemctl reboot
		;;
	$lock)
		playerctl pause || true
		~/.config/sway/blurry_swaylock.sh
		;;
	$suspend)
		playerctl pause || true
		systemctl suspend;
		;;
	$logout)
		loginctl terminate-user $USER
		;;
esac
