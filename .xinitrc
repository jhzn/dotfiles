#Truncate first
>xinitrc.log
#Then set stdout and stderr of remaining script to file
exec >> xinitrc.log
exec 2>&1

#Use bash instead of sh so we can use bashisms
if [[ x"$BASH" != x"/bin/bash" ]]; then
	exec /bin/bash "$HOME/.xinitrc"
fi


# Recommended by https://wiki.archlinux.org/index.php/Xinit#Configuration
# Taken from /etc/X11/xinit/xinitrc
# start some nice programs
if [ -d /etc/X11/xinit/xinitrc.d ] ; then
	 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
		[ -x "$f" ] && . "$f"
	 done
	 unset f
fi

#Setup daemons

#auto lockscreen
xscreensaver -no-splash &
#Start compositor
picom &
#notification daemon
#Because dunst does not support env varibles we do this
dunst -config <(envsubst < ~/.config/dunst/dunstrc) &
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
eval $(/usr/bin/gnome-keyring-daemon --daemonize --components=pkcs11,secrets,ssh)
export SSH_AUTH_SOCK

#Fix default X cursor
#details here: https://wiki.archlinux.org/index.php/Cursor_themes#Change_X_shaped_default_cursor
xsetroot -cursor_name left_ptr

[[ -f ~/.Xresources ]] && xrdb -merge -I$HOME ~/.Xresources

#run WM
exec bspwm
