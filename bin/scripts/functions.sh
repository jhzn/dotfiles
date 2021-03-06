#A collection of small functions which do not deserve being placed in a separate file
#These are sourced by the shell process

#Useful when you've cd'ed into a symlink to get the real path
function fix_cwd { cd $(pwd -P); }

#Generate a password
function gen_pass {
	head /dev/urandom | tr -dc A-Za-z0-9 | head -c 13 ; echo '';
}

function base64_encoded_to_png {
	[ -z "$1" ] && echo "No input received" && return

	echo $1 | sed -e 's#data:image/png;base64,##' | \
	base64 --decode > out.png && \
	echo "Created file named out.png";
}

function json_pretty {
	xclip -o | jq;
}
# restart services in docker-compose
dc-restart(){
	[ -z $@ ] && echo "No containers args given" && return 1
	docker-compose stop $@
	docker-compose rm -f -v $@
	docker-compose create --force-recreate $@
	docker-compose start $@
}

#colorize "go test" output to make it easier to parse for the eyes
#Example "go test | go_test_color"
function go_test_color {
	awk '{sub("FAIL","\033[31mFAIL\033[0m", $0); sub("PASS","\033[32mPASS\033[0m", $0); print}'
}

show_colour() {
    perl -e 'foreach $a(@ARGV){print "\e[48:2::".join(":",unpack("C*",pack("H*",$a)))."m \e[49m "};print "\n"' "$@"
}

# cf - fuzzy cd from anywhere
# ex: cf word1 word2 ... (even part of a file name)
# zsh autoload function
cf() {
  local file

  file="$(locate -Ai -0 $@ | grep -z -vE '~$' | fzf --read0 -0 -1)"

  if [[ -n $file ]]
  then
     if [[ -d $file ]]
     then
        cd -- $file
     else
        cd -- ${file:h}
     fi
  fi
}


# tm - create new tmux session, or switch to existing one. Works from within tmux too. (@bag-man)
# `tm` will allow you to select your tmux session via fzf.
# `tm irc` will attach to the irc session (if it exists), else it will create it.

tm() {
  [[ -n "$TMUX" ]] && change="switch-client" || change="attach-session"
  if [ $1 ]; then
    tmux $change -t "$1" 2>/dev/null || (tmux new-session -d -s $1 && tmux $change -t "$1"); return
  fi
  session=$(tmux list-sessions -F "#{session_name}" 2>/dev/null | fzf --exit-0) &&  tmux $change -t "$session" || echo "No sessions found."
}
