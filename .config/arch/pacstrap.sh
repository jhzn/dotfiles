#!/bin/sh

#Absolute minimum
pacstrap /mnt base linux linux-firmware base-devel grub neovim sudo man-db man-pages git networkmanager dhcpcd

#Disk crypto
cryptsetup

#WIFI
netctl dialog
