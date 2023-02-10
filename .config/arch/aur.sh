#!/bin/sh

if [ ! $(which paru) ]; then
	echo "AUR helper, paru not found, installing.."
	#Need rust to build
	git clone https://aur.archlinux.org/paru.git
	cd paru
	makepkg -si
	echo "AUR helper, paru is now installed!"
fi

paru -S --needed lf vscodium-bin \
	nerd-fonts-jetbrains-mono zeal \
	clipman wdisplays notify-send.sh \
	pandoc-bin wlsunset sway-launcher-desktop
