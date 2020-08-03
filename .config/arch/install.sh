#!/bin/bash

#Use this script post arch-installation
#--needed flags are used so that this script can be run multiple times without reinstalling everything and to achieve idempotence of packages across different machines

source ~/.config/dotfiles/bash_strict_mode.sh
if [ "$USER" != "root" ]; then
	#if we're not root, rerun as root and pass original user as argument to script
	exec sudo -E "$0" "$USER"
fi
#We're root now

#Validate some things
OG_USER="$1"
[ -z "$OG_USER" ] && echo "OG_USER is empty" && exit 1
[ $HOME != "/home/$OG_USER" ] && echo "Invalid HOME env var set = $HOME" && exit 1


#setup done, now we can do what we want to do







#xorg / GUI
pacman -S --needed xorg bspwm sxhkd dmenu rofi dunst slock xss-lock \
	xdg-utils lxsession xorg-setxkbmap xorg-xinit xf86-input-libinput \
	gnome-keyring libsecret \
	alacritty firefox network-manager-applet arandr \
	xclip redshift picom tmux transmission-gtk unclutter feh


echo "Setting up custom X11 conf.."
if ! /home/$OG_USER/.config/arch/X11.sh ; then
	echo ".. It went bad"
	exit 1
else
	echo ".. It went ok"
fi

#networking
pacman -S --needed iptables-nft
#audio
pacman -S --needed pulseaudio pulsemixer pavucontrol playerctl
#bluetooth
pacman -S --needed bluez bluez-utils pulseaudio-bluetooth
systemctl enable bluetooth && systemctl start bluetooth
#dev machine
pacman -S --needed python2 python3 go nodejs yarn rustup gnu-netcat openssh docker docker-compose
if [ ! $(which rustc) ]; then
	rustup default stable
fi

#shell
pacman -S --needed bash-completion
#setup vim
#check /README.md
pacman -S --needed python-pynvim
#theme/fonts
pacman -S --needed noto-fonts ttf-joypixels adapta-gtk-theme papirus-icon-theme lxappearance
#intel
#pacman -S --needed xf86-video-intel intel-ucode
#misc
pacman -S --needed sxiv gimp zathura zathura-pdf-poppler fzf ripgrep jq deepin-screenshot pandoc wmname youtube-dl units gnome-calculator
#files
pacman -S --needed unzip zip nemo pcmanfm syncthing exa
#disks
pacman -S --needed gnome-disk-utility gparted udiskie ncdu
#password manager
pacman -S --needed pass firefox-extension-passff
#firefox
pacman -S --needed firefox-dark-reader firefox-ublock-origin firefox-umatrix firefox-tridactyl

#laptop
if [ -e /sys/class/power_supply/BAT0/capacity ]; then
	pacman -S --needed powertop tlp tlp-rdw
	systemctl enable tlp && systemctl start tlp
fi

#install AUR packages
echo "Installing AUR packages.."
#Here we need to run yay as a non-root user because yay wants that
if ! sudo -u "$OG_USER" ~/.config/arch/aur.sh; then
	echo ".. It went bad"
	exit 1
else
	echo ".. It went ok"
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
