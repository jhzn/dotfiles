#!/bin/bash

source ~/.config/dotfiles/bash_strict_mode.sh

echo "Running Unittests for the dotfiles"

python ~/.config/sway/monitor_configer/generate_test.py

# Make sure these parse as valid JSON
jq '.' .config/waybar/aux_conf_template .config/waybar/primary_conf_template > /dev/null

echo "All is OK! 🎉🎉"
