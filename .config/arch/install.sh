#!/bin/sh -x

#Use this script post arch-installation


#xorg / GUI
pacman -S --needed xorg bspwm sxhkd dmenu rofi dunst xscreensaver \
	xdg-utils lxsession xorg-setxkbmap xorg-xinit xf86-input-libinput \
	gnome-keyring libsecret \
	alacritty firefox network-manager-applet \
	xclip redshift picom tmux transmission-gtk unclutter feh

#networking
pacman -S --needed iptables-nft
#audio
pacman -S --needed pulseaudio pulsemixer pavucontrol playerctl
#bluetooth
pacman -S --needed bluez bluez-utils pulseaudio-bluetooth
systemctl enable bluetooth && systemctl start bluetooth
#dev machine
pacman -S --needed python2 python3 go nodejs yarn rust gnu-netcat openssh docker docker-compose


#setup vim
#check /README.md
pacman -S --needed python-pynvim
#theme/fonts
pacman -S --needed noto-fonts ttf-joypixels adapta-gtk-theme papirus-icon-theme lxappearance
#intel
pacman -S --needed xf86-video-intel intel-ucode
#misc
pacman -S --needed sxiv gimp zathura zathura-pdf-poppler fzf ripgrep jq deepin-screenshot pandoc
#files
pacman -S --needed unzip zip nemo pcmanfm
#disks
pacman -S --needed gnome-disk-utility gparted udiskie ncdu

#laptop
if [ -e /sys/class/power_supply/BAT0/capacity ]; then
	pacman -S --needed powertop tlp tlp-rdw
	systemctl enable tlp && systemctl start tlp
fi


###########################
#### configure network ####
###########################

#wired
#systemctl start dhcpcd

#wireless
#use wifi-menu until x is stable
#use nm-applet now in GUI environment to connect to WIFI
#then
#systemctl stop/disable netctl@$WIFIPROFILE
#systemctl start/enable NetworkManager
#use nm-applet now in GUI environment to connect to WIFI
