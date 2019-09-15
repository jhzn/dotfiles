stty -ixon # Disable ctrl-s and ctrl-q in terminals.
shopt -s autocd #Allows you to cd into directory merely by typing the directory name.
HISTSIZE= HISTFILESIZE= # Infinite history.

source ~/bin/scripts/helpers.sh
source ~/.config/dotfiles/ps1.sh
source ~/.config/dotfiles/git.sh
source ~/.config/dotfiles/bash_aliases.sh

PATH=~/bin:$PATH
PATH=~/bin/scripts:$PATH
PATH=~/bin/scripts/emoji_finder.sh:$PATH
PATH=~/bin/scripts/latex-docker:$PATH
