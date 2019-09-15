#!/bin/bash

[ -z "$1" ] && echo "Missing .tex file argument which is passed to the latex build command" && exit 1

#Compile and take the script arguments and propagates them to the build command
latexdockerdaemoncmd.sh latexmk -cd -f -interaction=batchmode -pdf "$1"

#clean temp files
#latexdockerdaemoncmd.sh latexmk -c
#rm -rf .*aux .*latexmk .*fls .*log data
