#!/bin/sh

#Outputs a sequence of commands from machine A to be run on machine B
#Inspiration from https://stackoverflow.com/a/49398449
FILE="~/.config/dotfiles/vscode/extensions_installer.sh"

printf "#!/bin/sh\n" > $FILE
printf "#Do not edit directly! File is generated.\n" >> $FILE
codium --list-extensions | xargs -L 1 echo codium --install-extension >> $FILE
chmod +x $FILE
