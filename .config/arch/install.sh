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
[ "$HOME" != "/home/$OG_USER" ] && echo "Invalid HOME env var set = $HOME" && exit 1


#setup done, now we can do what we want to do

#desktop
pacman -S --needed lxsession gnome-keyring libsecret alacritty tmux firefox transmission-gtk brightnessctl

#hardens firefox a bit
cp ~/.config/arch/firefox/policies.json /usr/lib/firefox/distribution/policies.json

#xorg
pacman -S --needed xorg bspwm sxhkd rofi dunst xss-lock xsecurelock \
	xdg-utils xorg-setxkbmap xorg-xinit xf86-input-libinput \
	network-manager-applet arandr \
	xclip redshift picom unclutter feh deepin-screenshot wmname

# wayland
pacman -S --needed sway swaylock swayidle xorg-xwayland waybar gammastep mako grim slurp wl-clipboard wofi

echo "Setting up custom X11 conf.."
if ! "/home/$OG_USER/.config/arch/X11.sh" ; then
	echo ".. It went bad"
	exit 1
else
	echo ".. It went ok"
fi

#networking
pacman -S --needed iptables-nft
#audio
pacman -S --needed pipewire pipewire-pulse pulsemixer pavucontrol playerctl
#bluetooth
pacman -S --needed bluez bluez-utils
#systemctl enable bluetooth && systemctl start bluetooth
#development tools
pacman -S --needed python2 python3 go nodejs yarn rustup gnu-netcat openssh docker docker-compose
if [ ! "$(which rustc)" ]; then
	rustup default stable
fi

#shell
pacman -S --needed bash-completion zsh zsh-autosuggestions zsh-completions zsh-syntax-highlighting
#setup vim
#check /README.md
pacman -S --needed python-pynvim
#theme/fonts
pacman -S --needed noto-fonts ttf-joypixels adapta-gtk-theme papirus-icon-theme lxappearance
#intel
#pacman -S --needed xf86-video-intel intel-ucode
#images
pacman -S --needed imv gimp pinta imagemagick
#document handling/natural language
pacman -S --needed zathura zathura-pdf-poppler pandoc sdcv
#misc
pacman -S --needed fzf ripgrep jq \
	 youtube-dl units gnome-calculator newsboat speedtest-cli
#security
pacman -S --needed firejail
#if this holds true assume it's a fresh install of arch
if [ ! "$(which yay)" ]; then
	echo "Configuring firejail to be used by default!"
	#To use Firejail by default for all applications for which it has profiles, run the firecfg tool as root.
	#https://wiki.archlinux.org/index.php/Firejail#Using_Firejail_by_default
	firecfg
fi
#files
pacman -S --needed unzip zip nemo pcmanfm syncthing exa plocate
#disks
pacman -S --needed gnome-disk-utility gparted udiskie ncdu
#password manager
pacman -S --needed pass
#firefox
pacman -S --needed firefox-dark-reader firefox-ublock-origin firefox-tridactyl

#laptop
if [ -e /sys/class/power_supply/BAT0/capacity ]; then
	pacman -S --needed powertop tlp tlp-rdw
	#systemctl enable tlp && systemctl start tlp
fi

mkdir -p /etc/pacman.d/hooks/
cp ~/.config/arch/*.hook /etc/pacman.d/hooks/

#install AUR packages
echo "Installing AUR packages.."
#Here we need to run yay as a non-root user because yay wants that
if ! sudo -u "$OG_USER" ~/.config/arch/aur.sh; then
	echo ".. It went bad"
	exit 1
else
	echo "... AUR install went ok"
fi


