#!/bin/sh

set -euo pipefail

bluetoothctl power on

choice=$(bluetoothctl paired-devices | sort | fzfmenu)
choice_mac=$(echo "$choice" | awk '{print $2}')
choice_alias=$(echo "$choice" | awk '{print $3}')

bluetoothctl disconnect "$choice_mac"
bluetoothctl connect "$choice_mac"

if [ "$?" -ne 0 ]; then
	notify-send "Bluetooth" "Failed to connect" && exit 1
fi

notify-send "Bluetooth" "Connected to device: $choice_alias"

#let audio server catch up so that we can properly set audio down below
sleep 3
#set volume low when connecting in case volume get set to 100%
#it seems to be an recurring issue
audio.sh set 30
