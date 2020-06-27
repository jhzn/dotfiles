#
# ~/.bashrc

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

stty -ixon # Disable ctrl-s and ctrl-q in terminals.
shopt -s autocd #Allows you to cd into directory merely by typing the directory name.
#disabled CTRL + d in shell, this otherwise sends EOF to the shell
export IGNOREEOF=10

#Inifinte bash history
export HISTFILESIZE=
export HISTSIZE=
export HISTTIMEFORMAT="[%F %T] "

complete -cf sudo

#Activate vi mode in bash with ESC
set -o vi
#Add back shortcut of clearing the screen with CTRL + l
bind -m vi-insert "\C-l":clear-screen

source ~/.bash_aliases
source ~/bin/scripts/helpers.sh
source ~/.config/dotfiles/ps1.sh
#Make sure to never add this file to git!
source ~/.host_specific_settings.sh

PATH=~/bin:$PATH
PATH=~/bin/scripts:$PATH
PATH=~/bin/scripts/emoji_finder.sh:$PATH
PATH=~/bin/scripts/vimv:$PATH

export GOPATH=~/go
PATH=~/go/bin:$PATH
PATH=~/.cargo/bin:$PATH
PATH=~/.yarn/bin:$PATH

# FZF enable cool features
[ -f /usr/share/fzf/key-bindings.bash ] && . /usr/share/fzf/key-bindings.bash
[ -f /usr/share/fzf/completion.bash ] && . /usr/share/fzf/completion.bash

# Add lfcd function which allows the shell to cd to the path you navigate to in lf
source ~/.config/lf/lfcd.sh
bind '"\C-o":"lfcd\C-m"'  # bash
