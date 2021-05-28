# If not running interactively, don't do anything
[[ $- != *i* ]] && return

unset PS1

source ~/.profile

#CTRL+d no longer closes terminal
set -o ignoreeof

#begin history config

HISTFILE=~/.zsh_history
HISTFILESIZE=1000000000
SAVEHIST=1000000000
HISTSIZE=10000000
#Immediate append Setting the inc_append_history option ensures that commands are added to the history immediately (otherwise, this would happen only when the shell exits, and you could lose history upon unexpected/unclean termination of the shell).
setopt INC_APPEND_HISTORY
setopt EXTENDED_HISTORY
setopt HIST_FIND_NO_DUPS
setopt SHAREHISTORY
#make history behave like bash's
alias history='history 1'

# Prevent record in history entry if preceding them with at least one space
setopt hist_ignore_space
zstyle ':completion::complete:*' gain-privileges 1

#end of history config




# Basic auto/tab complete:
autoload -U compinit
zstyle ':completion:*' menu select
# Auto complete with case insenstivity
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'


zmodload zsh/complist
compinit
_comp_options+=(globdots)		# Include hidden files.



#begin vi config

# vi mode
bindkey -v
export KEYTIMEOUT=1

# Edit line in vim buffer ctrl-v
autoload edit-command-line; zle -N edit-command-line
bindkey '^v' edit-command-line
# Enter vim buffer from normal mode
autoload -U edit-command-line && zle -N edit-command-line && bindkey -M vicmd "v" edit-command-line

# Use vim keys in tab complete menu:
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'left' vi-backward-char
bindkey -M menuselect 'down' vi-down-line-or-history
bindkey -M menuselect 'up' vi-up-line-or-history
bindkey -M menuselect 'right' vi-forward-char
# Fix backspace bug when switching modes
bindkey "^?" backward-delete-char

# ci", ci', ci`, di", etc
autoload -U select-quoted
zle -N select-quoted
for m in visual viopp; do
  for c in {a,i}{\',\",\`}; do
    bindkey -M $m $c select-quoted
  done
done

# ci{, ci(, ci<, di{, etc
autoload -U select-bracketed
zle -N select-bracketed
for m in visual viopp; do
  for c in {a,i}${(s..)^:-'()[]{}<>bB'}; do
    bindkey -M $m $c select-bracketed
  done
done

# end of vi config






#autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
#zle -N up-line-or-beginning-search
#zle -N down-line-or-beginning-search

#[[ -n "${key[Up]}"   ]] && bindkey -- "${key[Up]}"   up-line-or-beginning-search
#[[ -n "${key[Down]}" ]] && bindkey -- "${key[Down]}" down-line-or-beginning-search





source ~/.bash_aliases
source ~/bin/scripts/functions.sh
#Make sure to never add this file to git!
source ~/.host_specific_settings.sh


# begin FZF config

[ -f /usr/share/fzf/key-bindings.zsh ] && source /usr/share/fzf/key-bindings.zsh
#overwrite exinting function to change "fc" to include timestampt as well.
#TODO make pull request to FZF github repo
# CTRL-R - Paste the selected command from history into the command line
fzf-history-widget() {
	local selected num
	setopt localoptions noglobsubst noposixbuiltins pipefail no_aliases 2> /dev/null
	selected=( $(fc -ril 1 | perl -ne 'print if !$seen{(/^\s*[0-9]+\**\s+(.*)/, $1)}++' |
	FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} $FZF_DEFAULT_OPTS -n2..,.. --tiebreak=index --bind=ctrl-r:toggle-sort,ctrl-z:ignore $FZF_CTRL_R_OPTS --query=${(qqq)LBUFFER} +m" $(__fzfcmd)) )
	local ret=$?
	if [ -n "$selected" ]; then
		num=$selected[1]
		if [ -n "$num" ]; then
			zle vi-fetch-history -n $num
		fi
	fi
	zle reset-prompt
	return $ret
}
[ -f /usr/share/fzf/completion.zsh ] && source /usr/share/fzf/completion.zsh
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
# To apply the command to CTRL-T as well
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"


# end of FZF config

# Add lfcd function which allows the shell to cd to the path you navigate to in lf
source ~/.config/lf/lfcd.sh
bindkey -s "^o" "lfcd\n"  # bash keybinding

eval $(/usr/bin/gnome-keyring-daemon --start --components=pkcs11,secrets,ssh)
export SSH_AUTH_SOCK

source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
#ZSH_AUTOSUGGEST_COMPLETION_IGNORE="git *"
bindkey '^ ' autosuggest-accept


#begin prompt config
function zle-line-init zle-keymap-select {
	PROMPT=$(purs prompt -k "$KEYMAP" -r "$?" --venv "${${VIRTUAL_ENV:t}%-*}" )
	zle reset-prompt
}
zle -N zle-line-init
zle -N zle-keymap-select

autoload -Uz add-zsh-hook

function _prompt_purs_precmd() {
	purs precmd --git-detailed
}
add-zsh-hook precmd _prompt_purs_precmd

# end of prompt config
