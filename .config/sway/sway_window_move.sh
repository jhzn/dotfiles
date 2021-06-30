#!/usr/bin/env bash

# Copyright (C) 2020-2021 Bob Hepple <bob.hepple@gmail.com>

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or (at
# your option) any later version.
#
# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
# General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program. If not, see <http://www.gnu.org/licenses/>.

# http://bhepple.freeshell.org

initialise() {
    PROG=$(basename $0)
    VERSION="1.0"
    ARGUMENTS="top-right|bottom-right|bottom-left"
    USAGE="move a floating window to top-right, bottom-right or bottom-left (sway lacks a way to do it!).
top-left is also provided for completeness although sway supports that."

    case $1 in
        -h|--help)
            echo "$USAGE"
            exit 0
            ;;
        top-left|top-right|bottom-right|bottom-left)
            command="$1"
            ;;
        *)
            echo "$PROG: bad argument" >&2
            exit 1
            ;;
    esac

    return 0
}

initialise "$@"
dimensions=$( swaymsg -t get_outputs |
    jq -r '.. | select(.focused?) | .current_mode | "\(.width)x\(.height)"' )

monitor_width=${dimensions%x*}
monitor_height=${dimensions#*x}

win_dim=( $( swaymsg -t get_tree |
        jq '.. | select(.type?) | select(.type=="floating_con") | select(.focused?)|.rect.width, .rect.height, .deco_rect.height' ) )

win_width=${win_dim[0]}
win_height=${win_dim[1]}
deco_height=${win_dim[2]}

#echo "$win_height $win_width $deco_height"

new_x=0
new_y=0
gap_size=10
case $command in
    top-right)
        new_x=$(( monitor_width -  win_width ))
        ;;

    bottom-right)
        new_x=$(( monitor_width -  win_width ))
        new_y=$(( monitor_height - win_height - deco_height ))
        ;;

    bottom-left)
        new_y=$(( monitor_height - win_height - deco_height ))
        ;;
esac

#new_x=$(( new_x - gap_size))
#new_y=$(( new_y - $((gap_size - 30)) ))

swaymsg "move position $new_x $new_y"
