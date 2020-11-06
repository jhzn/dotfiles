
#Allows running "config" as a way to always refer to my dotfiles git instance globally
#Also defines a git alias which can be used to update my dotfiles to the latest version
alias config="/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME -c status.showUntrackedFiles=no -c submodule.recurse=true -c alias.update="'"!bash '"$HOME"'/.config/dotfiles/update_dotfiles.sh"'

alias grep="grep --color=auto"
alias fgrep="fgrep --color=auto"
alias egrep="egrep --color=auto"

if [ -n "$WAYLAND_DISPLAY" ]; then
	alias xc="wl-copy --trim-newline"
	alias xp='wl-paste'
	export MOZ_ENABLE_WAYLAND=1
else
	#Copy to clipboard, also to VIM's "+ and "* register
	alias xc='xclip -i -selection primary -f | xclip -i -selection clipboard'
	#Output from clipboard
	alias xp='xclip -o'
fi

alias dc="docker-compose"
alias lad="lazydocker"
alias v="vim"
alias vim="nvim"

alias ls='exa --color=auto'
alias ll="exa -la"
alias l="exa -l"
alias cp="cp -iv"
#preserves the settings of the current user
#nvim for example uses the current user's settings instead of the root users
alias sudo="sudo -E"
#Allows moving the config file
alias tmux="tmux -f ~/.config/tmux/.tmux.conf"
#Easier to remember/type
alias open="xdg-open"
#screenshot in either x or sway
alias screenshot='[ -n "$WAYLAND_DISPLAY" ] && /usr/share/sway/scripts/grimshot || deepin-screenshot'
#shorter
alias bctl="bluetoothctl"
#set a standard terminal
alias ssh="TERM=screen-256color ssh"
alias diff="diff --color"
#alias dwl="dwl -s ~/.config/sway/wayland_startup.sh"
