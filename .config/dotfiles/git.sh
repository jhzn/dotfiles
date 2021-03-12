#!/bin/sh

#Run this script to apply git settings

git config --global alias.lg "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --date-order"
git config --global alias.st "status"
git config --global alias.cm "commit -m"
git config --global alias.co "checkout"
git config --global alias.br "branch"
git config --global alias.wip "! git add . && git commit -m 'WIP' && git push"
git config --global alias.authors "shortlog -s -n -e"

git config --global core.editor "nvim"
git config --global core.eol "lf"
git config --global core.autocrlf "input"
git config --global pull.ff only

echo "Updated global git config"
