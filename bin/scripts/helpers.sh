#!/bin/bash

function fix_cwd { cd $(pwd -P); }

function get_pass { head /dev/urandom | tr -dc A-Za-z0-9 | head -c 13 ; echo ''; }

function cat_all_and_search { find . -type f | xargs cat | grep -I -n -H $1; }

function base64_encoded_to_png { echo $1 | sed -e 's#data:image/png;base64,##' | base64 --decode > out.png && echo "Created file named out.png"; }

function json_pretty { xp | jq; }

function bananare { echo $1; }
