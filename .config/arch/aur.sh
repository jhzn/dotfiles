#!/bin/sh

if [ ! $(which paru) ]; then
	echo "AUR helper, paru not found, installing.."
	#Need rust to build
	git clone https://aur.archlinux.org/paru.git
	cd paru
	makepkg -si
	echo "AUR helper, paru is now installed!"
fi

paru -S --needed tealdeer-git lf vscodium-bin \
	nerd-fonts-jetbrains-mono zeal \
	clipman wdisplays notify-send.sh \
	autotiling-rs-git wlogout pandoc-bin wlsunset sway-launcher-desktop
