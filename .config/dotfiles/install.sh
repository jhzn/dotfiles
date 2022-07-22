#!/bin/bash

# This file should only contain idempotent commands

source ~/.config/dotfiles/bash_strict_mode.sh

~/.config/dotfiles/git.sh

#Make nemos 'Open in Terminal work'
# gsettings set org.cinnamon.desktop.default-applications.terminal exec $TERMINAL

nvim --headless +PackerUpdate +qa

mkdir -p ~/.config/nvm/
cp ~/.config/dotfiles/nvm/default-packages ~/.config/nvm/default-packages

pushd ~/.config/dotfiles/Layan-cursors
./install.sh
popd

ln -sf ~/.config/chromium-flags.conf ~/.config/brave-flags.conf
