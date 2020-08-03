#Truncate first
>xinitrc.log
#Then set stdout and stderr of remaining script to this file
exec >> xinitrc.log
exec 2>&1

# Recommended by https://wiki.archlinux.org/index.php/Xinit#Configuration
# Taken from /etc/X11/xinit/xinitrc
# start some nice programs
if [ -d /etc/X11/xinit/xinitrc.d ] ; then
	 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
		[ -x "$f" ] && . "$f"
	 done
	 unset f
fi
echo "DE is $1"

case "$1" in
	cinnamon)
	~/bin/scripts/x_settings.sh
	exec cinnamon-session
	;;
	bspwm)
	#Setup daemons

	#lock screen when we for example close laptop lid or systemctl suspend
	xss-lock xsecurelock &
	#Start compositor
	picom --backend glx &
	#notification daemon
	#Because dunst does not support env varibles we do this
	envsubst < ~/.config/dunst/dunstrc > /tmp/dunstrc && \
	dunst -config /tmp/dunstrc &
	#Keyboard shortcuts daemon
	sxhkd &
	#Network configurability tray
	nm-applet &
	#Blue light filter
	redshift-gtk &
	#Hide mouse after some time
	unclutter --timeout 3 &
	#automount block devcies
	udiskie --tray &
	#clipboard manager
	greenclip daemon &
	#polkit
	lxpolkit &
	#homemade cron
	~/bin/scripts/cron.sh &

	#start keyring daemon
	#https://wiki.archlinux.org/index.php/GNOME/Keyring
	# TODO is this optimal? We still need to run 'export $(gnome-keyring-daemon --start)' in our .bashrc
	#eval $(/usr/bin/gnome-keyring-daemon --daemonize --components=pkcs11,secrets,ssh)
	#export SSH_AUTH_SOCK

	[[ -f ~/.Xresources ]] && xrdb -merge -I$HOME ~/.Xresources

	#run WM
	exec bspwm
	;;
esac

echo "No DE/WM selected. Doing nothing then..." && exit 1

