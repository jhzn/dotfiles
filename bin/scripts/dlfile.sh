#!/bin/bash
# Provides the ability to download a file by dropping it into a window

url=$(dragon-drag-and-drop -t -x)
[ -z "$url" ] && echo "URL is empty" && exit 1

printf "File Name: "
read -r name
[ -z "$name" ] && echo "Empty name not allowed" && exit 1

if [ -e "$name" ]; then
	printf "File already exists, overwrite (y|n): "
	read -r ans
	[ "$ans" != "y" ] && exit 0
fi

# Download the file with curl
curl -L --output "$name" "$url"
