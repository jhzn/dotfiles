#!/bin/bash

input=$(slurp -o -f "%o")
xdg-desktop-portal --replace &
xdg-desktop-portal-wlr --replace -o "$input" &
