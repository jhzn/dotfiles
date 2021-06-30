#!/bin/sh

focuses_monitor=$(swaymsg -t get_outputs | jq -r '.. | select(.focused?) | .name')
