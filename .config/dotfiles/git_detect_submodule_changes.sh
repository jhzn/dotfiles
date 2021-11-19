#!/bin/bash

#used to get "config" alias
shopt -s expand_aliases
source ~/.bash_aliases

cfg submodule foreach git checkout master
cfg submodule foreach git remote update

echo "----------------------------------"

cfg submodule foreach git status -uno
