#!/bin/bash -x

NETWORK="192.168.1"

is_home() {
	if [[ $(ip route | grep default | awk '{print $3}' | grep $NETWORK) ]]; then
		echo 1
	else
		echo 0
	fi
}

if [[ $(playerctl status | grep Playing) ]]; then
	exit 1
fi
if [[ $(is_home) -eq 1 ]]; then
	exit 2
fi

eval "$@"
