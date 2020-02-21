stty -ixon # Disable ctrl-s and ctrl-q in terminals.
shopt -s autocd #Allows you to cd into directory merely by typing the directory name.
#disabled CTRL + d in shell, this otherwise sends EOF to the shell
export IGNOREEOF=10

#Inifinte bash history
export HISTFILESIZE=
export HISTSIZE=
export HISTTIMEFORMAT="[%F %T] "

export EDITOR=vim
#Activate vi mode in bash with ESC
set -o vi
#Add back shortcut of clearing the screen with CTRL + l
bind -m vi-insert "\C-l":clear-screen

source ~/bin/scripts/helpers.sh
source ~/.config/dotfiles/ps1.sh
source ~/.config/dotfiles/bash_aliases.sh

PATH=~/bin:$PATH
PATH=~/bin/scripts:$PATH
PATH=~/bin/scripts/emoji_finder.sh:$PATH
