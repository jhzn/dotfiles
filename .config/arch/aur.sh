#!/bin/sh

if [ ! $(which yay) ]; then
	echo "AUR helper, yay not found, installing.."
	#Need golang to build
	#https://github.com/Jguer/yay
	git clone https://aur.archlinux.org/yay.git
	cd yay
	makepkg -si
	echo "AUR helper, yay is now installed!"
fi

yay -S --needed polybar bottom-bin tealdeer-git lf vscodium-bin \
	nerd-fonts-jetbrains-mono zeal rofi-greenclip passff-host \
	sirula-git clipman wdisplays notify-send.sh autotiling-rs-git git-delta-bin wlogout pandoc-bin
