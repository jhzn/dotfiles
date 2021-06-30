#this file is used by both bash and zsh
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

export PICTURES="$HOME/Pictures"
export DOCUMENTS="$HOME/Documents"

export FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS'
--color=dark
--color=fg:-1,bg:-1,hl:#c678dd,fg+:#ffffff,bg+:#4b5263,hl+:#d858fe
--color=info:#98c379,prompt:#61afef,pointer:#be5046,marker:#e5c07b,spinner:#61afef,header:#61afef
'

export MONITOR_LAYOUT_FILE="$HOME/.cache/monitorlayout"
#Enables hardware decoding and wayland as compositor
export WAYLAND_CHROMIUM_FLAGS="--enable-features=VaapiVideoDecoder --enable-features=UseOzonePlatform --ozone-platform=wayland"

PATH=~/bin:$PATH
PATH=~/bin/scripts:$PATH
PATH=~/bin/scripts/emoji_finder.sh:$PATH
PATH=~/bin/scripts/vimv:$PATH

export GOPATH=~/go
export GOBIN=~/go/bin
PATH=~/go/bin:$PATH
PATH=~/.cargo/bin:$PATH
PATH=~/.yarn/bin:$PATH

