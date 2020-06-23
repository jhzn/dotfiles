#!/bin/sh -x

#Use this script post arch-installation


#xorg / GUI
pacman -S --needed xorg bspwm sxhkd dmenu rofi dunst xscreensaver \
	xdg-utils lxsession xorg-setxkbmap xorg-xinit xf86-input-libinput \
	gnome-keyring libsecret \
	alacritty firefox network-manager-applet  \
	xclip redshift picom tmux transmission-gtk unclutter feh

#audio
pacman -S --needed pulseaudio pulsemixer pavucontrol playerctl
#bluetooth
pacman -S --needed bluez bluez-utils pulseaudio-bluetooth
systemctl enable bluetooth && systemctl start bluetooth
#dev machine
pacman -S --needed python2 python3 go nodejs yarn rustup gnu-netcat openssh docker docker-compose
#Install rust toolchain
rustup install stable
rustup default stable


#setup vim
#check /README.md
pacman -S --needed python-pynvim
#theme/fonts
pacman -S --needed noto-fonts ttf-joypixels adapta-gtk-theme papirus-icon-theme lxappearance
#intel
pacman -S --needed xf86-video-intel intel-ucode
#utils
pacman -S --needed sxiv gimp zathura zathura-pdf-poppler fzf ripgrep jq
#files
pacman -S --needed unzip zip nemo pcmanfm
#disks
pacman -S --needed gnome-disk-utility gparted udiskie ncdu
#laptop
pacman -S --needed powertop tlp tlp-rdw
systemctl enable tlp && systemctl start tlp


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
