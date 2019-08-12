#!/bin/bash

#used to get "config" alias
shopt -s expand_aliases
source $HOME/.config/dotfiles/bash_aliases.sh

config submodule init && \
config submodule update && \
config pull && \
echo "Updated dotfiles!"
