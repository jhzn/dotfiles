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


export HISTCONTROL=ignoredups:erasedups  # no duplicate entries
shopt -s histappend                      # append to history, don't overwrite it

# Save and reload the history after each command finishes
export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"



#By default Bash only tab-completes file names following a command. You can change it to complete command names using
complete -c man which
#complete command names and file names with
complete -cf sudo

#Activate vi mode in bash with ESC
set -o vi
#Add back shortcut of clearing the screen with CTRL + l
bind -m vi-insert "\C-l":clear-screen

source ~/.shell_aliases
source ~/bin/scripts/functions.sh
source ~/.config/dotfiles/ps1.sh
#Make sure to never add this file to git!
source ~/.host_specific_settings.sh

# FZF enable cool features
[ -f /usr/share/fzf/key-bindings.bash ] && . /usr/share/fzf/key-bindings.bash
[ -f /usr/share/fzf/completion.bash ] && . /usr/share/fzf/completion.bash

# Add lfcd function which allows the shell to cd to the path you navigate to in lf
source ~/.config/lf/lfcd.sh
bind '"\C-o":"lfcd\C-m"'  # bash keybinding

#Bash autocomplettions
source /usr/share/bash-completion/bash_completion

#run-help() { help "$READLINE_LINE" 2>/dev/null || man "$READLINE_LINE"; }
#bind -m vi-insert -x '"\eh": run-help'

eval $(/usr/bin/gnome-keyring-daemon --start --components=pkcs11,secrets,ssh 2> /dev/null)
export SSH_AUTH_SOCK
