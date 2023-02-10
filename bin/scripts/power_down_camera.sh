#!/bin/bash

source ~/.config/dotfiles/bash_strict_mode.sh

if [ $EUID != 0 ]; then
    exec sudo -E "$0" "$@"
    exit $?
fi

device_id() {
	regex='\/sys\/bus\/usb\/devices\/(.*)\/product'
	echo "$1" | sed -E "s/$regex/\\1/"
}

usb_enable() {
	echo "Enabling device by id: $1"
	echo "$1" | sudo tee /sys/bus/usb/drivers/usb/bind
}

usb_disable() {
	echo "Disabling device by id: $1"
	echo "$1" | sudo tee /sys/bus/usb/drivers/usb/unbind
}

disable_patterns=('HP HD Camera' 'HP Truevision Full HD')

for device in $(ls /sys/bus/usb/devices/*/product); do
	device_name=$(cat $device)
		# echo "Path: $device Name: $device_name"

	for p in ${disable_patterns[@]}; do
		if [[ "$p" == "$device_name" ]]; then
			# echo "match $p == $device_name"

			id=$(device_id "$device")
			result="$(usb_disable "$id" 2>&1 || true )"

			if [[ $(echo "$result" | grep "No such device" || true) ]]; then
				echo "'$device_name' is already disabled"
			fi
		fi
	done
done

if [ $? -eq 0 ]; then
	echo "Success"
else
	echo "Failure"
fi
