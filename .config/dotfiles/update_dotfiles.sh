#!/bin/bash

#used to get "config" alias
shopt -s expand_aliases
source ~/.bash_aliases

config submodule init && \
config submodule update && \
config pull && \
~/.config/dotfiles/install.sh && \
echo "Updated dotfiles from git repo and updated settings!"
