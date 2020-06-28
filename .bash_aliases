
#Allows running "config" as a way to always refer to my dotfiles git instance globally
#Also defines a git alias which can be used to update my dotfiles to the latest version
alias config="/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME -c status.showUntrackedFiles=no -c submodule.recurse=true -c alias.update="'"!bash '"$HOME"'/.config/dotfiles/update_dotfiles.sh"'

alias grep="grep --color=auto"
alias fgrep="fgrep --color=auto"
alias egrep="egrep --color=auto"

alias xc="xclip -i -selection primary -f | xclip -i -selection clipboard" #Copy to clipboard, also to VIM's "+ and "* register
alias xp="xclip -o" #Output from clipboard

alias dc="docker-compose"
alias lad="lazydocker"
alias v="vim"
alias vim="nvim"

alias ls='ls --color=auto'
alias ll="ls -la"
alias l="ls -l"
alias cp="cp -iv"
#preserves the settings of the current user
#nvim for example uses the current user's settings instead of the root users
alias sudo="sudo -E"
#Allows moving the config file
alias tmux="tmux -f ~/.config/tmux/.tmux.conf"
#Easier to remember/type
alias open="xdg-open"
#more generic
alias screenshot="deepin-screenshot"
#shorter
alias bctl="bluetoothctl"
