#!/bin/bash

function fix_cwd { cd $(pwd -P); }

#Generate a password
function get_pass { head /dev/urandom | tr -dc A-Za-z0-9 | head -c 13 ; echo ''; }

function cat_all_and_search { find . -type f | xargs cat | grep -I -n -H $1; }

function base64_encoded_to_png { echo $1 | sed -e 's#data:image/png;base64,##' | base64 --decode > out.png && echo "Created file named out.png"; }

function json_pretty { xclip -o | jq; }

function line_count_files_with_extension_in_cwd { 
	if [ -n "$1" ]
	then 
		find . -name '*.'"$1" | xargs wc -l | sort -nr
	else
		echo 'Missing file extension as 1st argument. Example: txt, md, sh'
	fi;
} 

function bananare { echo $1; }
