#!/bin/sh

#Outputs a sequence of commands from machine A to be run on machine B
#Inspiration from https://stackoverflow.com/a/49398449
FILE=~/.config/dotfiles/vscode/extensions_installer.sh

printf "#!/bin/sh\n" > $FILE
code --list-extensions | xargs -L 1 echo code --install-extension >> $FILE
chmod +x $FILE
