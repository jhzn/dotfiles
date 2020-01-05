#A collection of small functions which do not deserve being placed in a separate file
#These are sourced by the shell process

#Useful when you've cd'ed into a symlink to get the real path
function fix_cwd { cd $(pwd -P); }

#Generate a password
function gen_pass { head /dev/urandom | tr -dc A-Za-z0-9 | head -c 13 ; echo ''; }

function base64_encoded_to_png { echo $1 | sed -e 's#data:image/png;base64,##' | base64 --decode > out.png && echo "Created file named out.png"; }

function json_pretty { xclip -o | jq; }
