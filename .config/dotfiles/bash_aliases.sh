alias config="/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME -c status.showUntrackedFiles=no -c submodule.recurse=true -c alias.update="'"!bash '"$HOME"'/.config/dotfiles/update_dotfiles.sh"'

alias grep="grep --color=auto"
alias fgrep="fgrep --color=auto"
alias egrep="egrep --color=auto"

alias xc="xclip -i -selection primary -f | xclip -i -selection clipboard" #Copy to clipboard, also to VIM's "+ and "* register
alias xp="xclip -o" #Output from clipboard

alias dc="docker-compose"
alias lad="lazydocker"
alias v="vim"

