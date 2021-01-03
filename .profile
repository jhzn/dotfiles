#this files is used by both bash and zsh

export EDITOR="nvim"
export READER="zathura"
export VISUAL="nvim"
export CODEEDITOR="vscodium"
export TERMINAL="alacritty"
export BROWSER="firefox"
export COLORTERM="truecolor"
export PAGER="less"
#export WM="bspwm"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"

PATH=~/bin:$PATH
PATH=~/bin/scripts:$PATH
PATH=~/bin/scripts/emoji_finder.sh:$PATH
PATH=~/bin/scripts/vimv:$PATH

export GOPATH=~/go
export GOBIN=~/go/bin
PATH=~/go/bin:$PATH
PATH=~/.cargo/bin:$PATH
PATH=~/.yarn/bin:$PATH

