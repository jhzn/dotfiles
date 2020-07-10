#!/bin/bash

tee /etc/X11/xorg.conf.d/johan.conf <<XORG_CONF
Section "ServerFlags"
	 Option "DontVTSwitch" "True"
	 Option "DontZap"      "True"
EndSection
XORG_CONF
