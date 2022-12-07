#!/bin/bash

# Inspiration from:
# https://old.reddit.com/r/swaywm/comments/qroubv/help_how_to_use_wtype/

# Bash strict mode
set -eo pipefail
# Neat way to show the line and program which caused the error in a pipeline
trap 's=$?; echo >&2 "$0: Error on line "$LINENO": $BASH_COMMAND"; exit $s' ERR

if [ "$1" != "INSIDEWINDOW" ]; then
	chosen_script_to_execute=$(find ~/bin/scripts -executable -type f | sed 's@'"$HOME"'/bin/scripts/@@' | sort | fzfmenu)
	# Recursive call to the same script
	# However as INSIDEWINDOW is set we don't enter this if case here
	# exec replaces the current process running this script with the chosen script which we selected above
	exec "$0" INSIDEWINDOW $$ "$chosen_script_to_execute"
fi

# We end up here once we've recursed one time

# TODO explain what this does
# I barely get it
exec >/proc/$2/fd/1 </proc/$2/fd/0

# Discards potitional arguments $1 $2
# At this point we're only interested in the argument which are relevant to the purpose of this script
# $1 and $2 are an implementation detail to make this script work
shift; shift;

exec ~/bin/scripts/$1
