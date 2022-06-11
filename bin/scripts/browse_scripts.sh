#!/bin/bash

~/bin/scripts/$( find ~/bin/scripts -executable -type f | sed 's@'"$HOME"'/bin/scripts/@@' | sort | fzfmenu)
