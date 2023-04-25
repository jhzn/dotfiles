#!/bin/bash -x

input=$(slurp -o -f "%o")
xdg-desktop-portal -v --replace &
sleep 1
xdg-desktop-portal-wlr --loglevel=DEBUG &
