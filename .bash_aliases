
#Allows running "config" as a way to always refer to my dotfiles git instance globally
#Also defines a git alias which can be used to update my dotfiles to the latest version
alias config="/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME -c status.showUntrackedFiles=no -c submodule.recurse=true -c alias.update="'"!bash '"$HOME"'/.config/dotfiles/update_dotfiles.sh"'
alias cfg="config"



alias grep='grep --colour=auto'
alias egrep='egrep --colour=auto'
alias fgrep="fgrep --color=auto"

if [ -n "$WAYLAND_DISPLAY" ]; then
	alias xc="wl-copy --trim-newline"
	alias xp='wl-paste --type text'
	alias screenshot='/usr/share/sway/scripts/grimshot'
else
	#Copy to clipboard, also to VIM's "+ and "* register
	alias xc='xclip -i -selection primary -f | xclip -i -selection clipboard'
	#Output from clipboard
	alias xp='xclip -o'
	#screenshot in either x or sway
	alias screenshot='deepin-screenshot'
fi

alias dc="docker-compose"
alias lad="lazydocker"
alias v="nvim"
alias vim="nvim"
alias g="git"

#replace ls with exa
alias ls='exa'
alias l='ls --color=auto --group-directories-first --classify'
alias ll='ls --color=auto --group-directories-first --classify -l'
alias lla='ls --color=auto --group-directories-first --classify -la'
#preserves the settings of the current user
#nvim for example uses the current user's settings instead of the root users
alias sudo="sudo -E"
#Allows moving the config file
alias tmux="tmux -f ~/.config/tmux/.tmux.conf"
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

#natural language dictionary
alias dic="sdcv"

alias cal="cal -3 --monday --week --color=always"
