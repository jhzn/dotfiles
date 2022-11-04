#!/bin/bash

source ~/.config/dotfiles/bash_strict_mode.sh

source ~/bin/scripts/functions.sh # Access to config function

echo "Running Unittests for the dotfiles"

python ~/.config/sway/monitor_configer/generate_test.py > /dev/null

# Make sure these parse as valid JSON
jq '.' .config/waybar/aux_conf_template .config/waybar/primary_conf_template > /dev/null


# Make sure I'm using the right author
#
# Validate git history
email="jhakanzon@gmail.com"
submodule_count=$(config submodule foreach git authors | grep -i johan | grep -v "$email" | wc -l || true)
if [[ "$submodule_count" != 0 ]]; then
	echo "Found invalid author email address being used in submodule"
	exit 1
fi
main_repo_count=$(config authors | grep -i johan | grep -v "$email" | wc -l || true)
if [[ "$main_repo_count" != 0 ]]; then
	echo "Found invalid author email address being used on main repo"
	exit 1
fi
# Validate current git settings
if [[ "$(config config user.email)" != "$email" ]]; then
	echo "Found invalid author email address being used"
	exit 1
fi
emails=("$(config submodule --quiet foreach git config user.email)")
for e in $emails;
do
	if [[ "$e" != "$email" ]]; then
		echo "Found invalid author email address being used"
		exit 1
	fi
done




echo "All is OK! 🎉🎉"
