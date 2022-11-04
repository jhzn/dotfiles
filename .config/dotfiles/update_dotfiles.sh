#!/bin/bash
#
source ~/.config/dotfiles/bash_strict_mode.sh

#used to get "config" function
source ~/bin/scripts/functions.sh

config submodule init
config submodule update
config pull
~/.config/dotfiles/install.sh

# Set my personal email address so that I don't accidentally commit with another email
email="jhakanzon@gmail.com"
config config user.email "$email"
config submodule foreach "git config user.email $email"

echo "Updated dotfiles from git repo and updated settings!"
