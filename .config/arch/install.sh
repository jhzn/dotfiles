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
pacman -S --needed xdg-user-dirs lxsession gnome-keyring libsecret alacritty tmux \
	firefox transmission-gtk brightnessctl network-manager-applet kdeconnect

#hardens firefox a bit
cp ~/.config/arch/firefox/policies.json /usr/lib/firefox/distribution/policies.json

# wayland
pacman -S --needed sway swaylock swayidle xorg-xwayland waybar gammastep mako grim slurp wl-clipboard wofi

#networking
pacman -S --needed iptables-nft
#audio
pacman -S --needed pipewire pipewire-pulse pulsemixer pavucontrol playerctl
#bluetooth
pacman -S --needed bluez bluez-utils
#systemctl enable bluetooth && systemctl start bluetooth

#development tools
pacman -S --needed python3 python-pip go nodejs npm yarn rustup \
	gnu-netcat openssh docker docker-compose git-delta
if [ ! "$(which rustc)" ]; then
	rustup default stable
fi
pip3 install requests
yarn global add bash-language-server

#shell
pacman -S --needed bash-completion zsh zsh-autosuggestions zsh-completions zsh-syntax-highlighting
#setup vim
#check /README.md
pacman -S --needed python-pynvim
#theme/fonts
pacman -S --needed noto-fonts ttf-joypixels ttf-font-awesome adapta-gtk-theme papirus-icon-theme lxappearance
#intel
#pacman -S --needed xf86-video-intel intel-ucode
#images
pacman -S --needed imv gimp swappy imagemagick
#document handling/natural language
pacman -S --needed zathura zathura-pdf-poppler sdcv texlive-core
#misc
pacman -S --needed fzf ripgrep jq \
	youtube-dl units gnome-calculator newsboat speedtest-cli bat bottom s-tui mpv tealdeer
#security
pacman -S --needed doas
#files
pacman -S --needed unzip zip nemo pcmanfm syncthing exa plocate
#disks
pacman -S --needed gnome-disk-utility gparted udiskie ncdu
#password manager
pacman -S --needed pass
#browser
pacman -S --needed qutebrowser python-adblock chromium \
	firefox-dark-reader firefox-ublock-origin firefox-tridactyl

#laptop
if [ -e /sys/class/power_supply/BAT0/capacity ]; then
	pacman -S --needed powertop tlp tlp-rdw
	#systemctl enable tlp && systemctl start tlp
fi

mkdir -p /etc/pacman.d/hooks/
cp ~/.config/arch/*.hook /etc/pacman.d/hooks/

#install AUR packages
echo "Installing AUR packages.."
#Here we need to run paru as a non-root user because paru wants that
if ! sudo -u "$OG_USER" ~/.config/arch/aur.sh; then
	echo ".. It went bad"
	exit 1
else
	echo "... AUR install went ok"
fi


