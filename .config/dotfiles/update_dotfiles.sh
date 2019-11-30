#!/bin/bash

#used to get "config" alias
shopt -s expand_aliases
source ~/.config/dotfiles/bash_aliases.sh

config submodule init && \
config submodule update && \
config pull && \
~/.config/dotfiles/git.sh && \
echo "Updated dotfiles from git repo and updated settings!"
