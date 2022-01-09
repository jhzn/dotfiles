#!/bin/sh

~/.config/dotfiles/git.sh

#Make nemos 'Open in Terminal work'
gsettings set org.cinnamon.desktop.default-applications.terminal exec $TERMINAL

nvim --headless +PackerUpdate +qa
