alias xc="xclip -sel clip"
alias xp="xclip -o"
alias grep="grep --color=auto"
alias fgrep="fgrep --color=auto"
alias egrep="egrep --color=auto"

alias dc="docker-compose"
alias lad="lazydocker"

alias config="/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME -c status.showUntrackedFiles=no -c submodule.recurse=true -c alias.update="'"!bash '"$HOME"'/.config/dotfiles/update_dotfiles.sh"'
