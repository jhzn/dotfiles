if [ -n "$WAYLAND_DISPLAY" ]; then
	alias xc="wl-copy --trim-newline"
	alias xp='wl-paste --type text'
	alias screenshot='/usr/share/sway/scripts/grimshot'
	alias codium="codium $WAYLAND_CHROMIUM_FLAGS"
else
	#Copy to clipboard, also to VIM's "+ and "* register
	alias xc='xclip -i -selection primary -f | xclip -i -selection clipboard'
	#Output from clipboard
	alias xp='xclip -o'
	#screenshot in either x or sway
	alias screenshot='deepin-screenshot'
fi

#doas ftw
#alias sudo="doas" I have a function which override some behavior in addition to acting as an alias
alias sudoedit="doasedit"
alias paru="paru --sudo=doas"
alias paruu="paru --sudo=doas -Syu"

alias code="codium"
alias dc="docker-compose"
alias dc_start="dc down --remove-orphans && dc build && dc up"

alias lad="lazydocker"
alias g="git"

alias v="nvim"
alias vim="nvim"
alias j='nvim -R -c "set ft=json"'
alias pager="nvim -R"

alias grep='grep --colour=auto'
alias egrep='egrep --colour=auto'
alias fgrep="fgrep --color=auto"

#replace ls with exa
alias ls='exa'
alias l='ls --color=auto --group-directories-first --classify'
alias ll='ls --color=auto --group-directories-first --classify -l'
alias lla='ls --color=auto --group-directories-first --classify -la'

alias ..="cd .."
alias ....="cd ../.."

#Allows moving the config file
alias tmux="tmux -2 -f ~/.config/tmux/tmux.conf"
#Easier to remember/type
alias open="xdg-open"
#shorter
alias bctl="bluetoothctl"
#set a standard terminal
alias ssh="TERM=screen-256color ssh"
alias diff="diff --color"

#More verbose output of common commands
alias cp='cp -iv'
alias rcp='rsync -v --progress'
alias rmv='rsync -v --progress --remove-source-files'
alias mv='mv -iv'
alias rm='rm -iv'
alias rmdir='rmdir -v'
alias ln='ln -v'
alias chmod="chmod -c"
alias chown="chown -c"
alias mkdir="mkdir -v"
alias less="less --status-column"

#natural language dictionary
alias dic="STARDICT_DATA_DIR=~/.config/stardict/dic sdcv"

alias cal="cal -3 --monday --week --color=always"
alias ne="nix-env"
alias p="python3"

alias tmux_dlv="tmux split-window -v -t sc \"zsh -ic 'dlv connect localhost:2345'\""

