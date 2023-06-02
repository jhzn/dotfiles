# A collection of small functions which do not deserve being placed in a separate file
# These are sourced by the shell process

# Allows running "config" as a way to always refer to my dotfiles git instance globally
# Also defines a git alias which can be used to update my dotfiles to the latest version
config() {
	# This is only need for the Github CI to work properly
	# There we don't use the bootstrap script
	git_dir="${OVERRIDE_DOTFILES_GIT_DIR:-$HOME/.dotfiles/}"
	git \
		--git-dir="$git_dir" \
		--work-tree="$HOME" \
		-c status.showUntrackedFiles=no \
		-c submodule.recurse=true \
		-c core.hooksPath="$HOME/.config/dotfiles/git_hooks/" \
		-c alias.update="!bash $HOME/.config/dotfiles/update_dotfiles.sh" \
		"$@"
}
alias cfg="config"
alias c="config"
# A better name than config, should replace config
# Removing when old aliases when muscle memory has adjusted :)
alias dotfiles="config"
alias d="config"

# Useful when you've cd'ed into a symlink to get the real path
fix_cwd() { cd $(pwd -P); }

# cd to git root
cdr() {
	cd "$(git rev-parse --show-toplevel)"
}

# Generate a password
pass_gen() {
	head /dev/urandom | tr -dc A-Za-z0-9 | head -c 13 ; echo '';
}

# Get a random UUID
uuid_gen() {
	cat /proc/sys/kernel/random/uuid
}

base64_encoded_to_png() {
	[ -z "$1" ] && echo "No input received" && return

	echo $1 | sed -e 's#data:image/png;base64,##' | \
	base64 --decode > out.png && \
	echo "Created file named out.png";
}

# Pretty print JSON from the clipboard
jsonp() {
	# xp is an alias to paste from clipboard
	xp | jq;
}

# Convert a printed python object to json
py_json() {
	python3 -c "import json; print(json.dumps($(xp), indent=2))"
}

# restart services in docker-compose
dc-restart(){
	[ -z $@ ] && echo "No containers args given" && return 1
	docker-compose stop $@
	docker-compose rm -f -v $@
	docker-compose create --force-recreate $@
	docker-compose start $@
}

# returns the default app for opening a certain file
mime() {
	[ -z "$1" ] && echo "Missing file arg" && return 1
	[ ! -e "$1" ] && echo "Given arg does not match anything existing" && return 2
	xdg-mime query default $(xdg-mime query filetype "$1")
}

# colorize "go test" output to make it easier to parse for the eyes
# Example "go test . | go_test_color"
go_test_color() {
	forground_color='[97;' # White
	if [[ "$ZSH_THEME" == "light" ]]; then
		forground_color='[30;' # black
	fi
	awk \
		-v ESC='\033' \
		-v COLOR_RED='[31m' \
		-v COLOR_YELLOW='[33m' \
		-v COLOR_GREEN='[32m' \
		-v COLOR_MAGENTA='[35m' \
		-v COLOR_CYAN='[34m' \
		-v COLOR_BLUE_BG='104m' \
		-v COLOR_FOREGROUND="$forground_color" \
		-v RESET='[0m' \
		'{
		sub("FAIL", ESC COLOR_RED "FAIL" ESC RESET, $0);
		sub("ERROR",ESC COLOR_RED "ERROR" ESC RESET, $0);
		sub("WARN", ESC COLOR_YELLOW "WARN" ESC RESET, $0);
		sub("PASS", ESC COLOR_GREEN "PASS" ESC RESET, $0);
		sub(/=== RUN.+$/, ESC COLOR_FOREGROUND COLOR_BLUE_BG "&" ESC RESET, $0);
		sub("P_DEBUG", ESC COLOR_MAGENTA "P_DEBUG" ESC RESET, $0);

		# When t.Errorf("MyMessage") or t.Logf("MyMessage") is called it outputs for example: "    /a/path/to/testfile.go:12 MyMessage". This case catches that and highlights it
		# & is a special character in awk.
		# Source: https://www.gnu.org/software/gawk/manual/html_node/String-Functions.html
		# "If the special character ‘&’ appears in replacement, it stands for the precise substring that was matched by regexp"
		sub(/( ){4}(.+)\/?([^\/]+).go:[0-9]+:/,
			ESC COLOR_MAGENTA "Test case outputted @:" ESC COLOR_CYAN "&" ESC RESET,
			$0);
		print
	}'
}

# Prints and runs a command
echo_and_run() {
	echo "Running: '$@'"
	eval $(printf '"%b" ' "$@") < /dev/tty
}

# Notifies via pop up and sound
# Very useful in a pipeline
notify_done() {
	action=${1:-"Action"}
	code=${2:-"$?"}
	echo "notify_done $code"

	say() {
		volume="-70"
		spd-say --volume "$volume" "$action $1"
	}

	if [ "$code" -eq 0 ]; then
		notify-send --urgency=low -t 10000 "$action done!" "Result = 👍"
		say "ok"
	else
		notify-send --urgency=low -t 10000 "$action done!" "Result = 👎"
		say "fail"
	fi
}

# Better defaults for running "go test ..."
gotest() {
	set -o pipefail
	time echo_and_run \
		go test -cover -failfast -race -v "$@" | go_test_color
	code=$?
	# Notifies us via pop up and sound in case the shell's terminal is not currently focused
	# Helpful when multitasking
	notify_done "Test" "$code"
	set +o pipefail
	return $code
}

# tm - create new tmux session, or switch to existing one. Works from within tmux too. (@bag-man)
# `tm` will allow you to select your tmux session via fzf.
# `tm x` will attach to the irc session (if it exists), else it will create it.
tm() {
	[[ -n "$TMUX" ]] && change="switch-client" || change="attach-session"
	session_name="$1"
	if [[ "$session_name" == "n" ]]; then
		git_branch=$(git branch --show-current)
		[ -z "$git_branch" ] && echo "No Git branch found!" && return

		if [[ "$git_branch" == "master" || "$git_branch" == "main" ]]; then
			session_name="$PWD"'@'"$git_branch"
		else
			session_name="$git_branch"
		fi
		tmux new-session -s $session_name
		return
	fi
	if [ "$session_name" ]; then
		tmux $change -t "$session_name" 2>/dev/null || (tmux new-session -d -s $session_name && tmux $change -t "$session_name"); return
	fi
	session=$(tmux list-sessions -F "#{session_name}" 2>/dev/null | fzf --exit-0) &&  tmux $change -t "$session" || echo "No sessions found."
}

# Watch a youtube video
wv() {
	mpv --ytdl-format="$YT_DL_FORMAT" "$1"
}

# Better branch creation ergonomics when using git worktrees
create_branch() {
	if [ ! -f "HEAD" ]; then
		echo "You're not in the root of the bare repo. Aborting..."; return 1
	fi

	branch_name="$1"
	if [ -z "$branch_name" ]; then
		branch_name="$(git branch -a --format '%(refname:short)' | fzf)"
	else
		git branch "$branch_name"
	fi
	if [ -z "$branch_name" ]; then
		echo "Missing first arg for branch name. Aborting..."; return 1
	fi

	# Removes everything before the last forward slash(/)
	# example "some/branch/name" will be "name"
	dir="branches/${branch_name##*/}"
	git worktree add "$dir" "$branch_name"
	echo "Created dir: $dir"
	cd "$dir"
}

retry() {
	for i in {1..20}; do
		eval "$@"
		sleep 1
	done
}

# Open a new pane while in a tmux session which tries to connect to a running dlv server
tmux_delve() {
	tmux split-window -h -t sc "zsh -ic 'retry dlv connect localhost:2345'"
}

# Changes a MAC address from ac:cc:8f:01:0e:45 -> ACCC8F010E45
clean_mac() {
	printf "$1" | sed 's/://g' | tr '[:lower:]' '[:upper:]'
}

# Count columns in the output of a command to more easily map {print $x} when writing a awk command
awk_columns() {
	awk 'BEGIN {FS=" "} END {print NF}'
}

# Show a file from the git history
git_file() {
	set -x

	option=$(printf "Branch\nCommit" | fzf)

	if [[ "$option" == "Branch" ]]; then
		ref="$(git branch -a --format '%(refname:short)' | fzf --header 'Pick a branch')"
	fi
	if [[ "$option" == "Commit" ]]; then
		ref="$(git log --color --abbrev-commit --date-order \
			--pretty=format:'%Cred%H%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' | \
			fzf --ansi --header 'Pick a commit' | awk '{print $1}')"
	fi

	[ -z "$ref" ] && echo "Branch or commit is empty" && return

	project_root_dir=$(git rev-parse --show-toplevel)
	file=$(cd "$project_root_dir" && fzf --header 'File path?')
	[ -z "$file" ] && return

	file_extension="${file##*.}"
	git show "$ref:$file" | nvim -R -c "setlocal buftype=nofile ft=$file_extension"
	set +x
}

urlencode() {
	python3 -c "import urllib.parse; print(urllib.parse.quote('''$1'''))"
}
urldecode() {
	python3 -c "import urllib.parse; print(urllib.parse.unquote('''$1'''))"
}

# Query for clipboard history
# Example usage: delta <(xhist 0) <(xhist 1)
# Diffs last and item before last in clipboard
xhist() {
	index=0
	if [[ -n "$1" ]]; then
		index="$1"
	fi
	# The public API uses 0 as the latest entry however that is not the internal index
	index=$((index+1))
	jq -r ".[-$index]" ~/.local/share/clipman.json
}

# Diff last clipboard entry with entry before last
xdiff() {
	delta <(xhist 0) <(xhist 1)
}
xdiff_json() {
	delta <(xhist 0 | jq) <(xhist 1 | jq)
}
# Hexadecimal to decimal
hex(){
	if [[ ! $(echo "$1" | grep "0x") ]]; then
		echo "'$1' is not a hex value"
		return 1
	fi
	printf "%d\n" "$1"
}
