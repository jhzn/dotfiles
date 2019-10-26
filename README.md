### 1st time Setup

```bash
#All we care about is the .git folder which is placed in ~/.dotfiles and then a git reset --hard is used to place the contents of the repo in the HOME dir.
#git reponds with error if you try to clone a repos content directly into a directory which already has content. This circumvents that.
#Run this in an interactive shell

cd ~ && \
git clone --separate-git-dir=$HOME/.dotfiles https://github.com/jhzn/dotfiles $HOME/dotfiles-tmp && \
rm -rf dotfiles-tmp && \
source <(echo 'alias config="/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME"') && \
config reset --hard && \
echo "source ~/.config/dotfiles/bash_opts.sh" >> ~/.bashrc && \
source ~/.bashrc && \
config update && \
echo "Successfully setup dotfiles! Open a new shell to finalize!"
```

### Subsequent updating
```bash
#Custom git alias to update dotfiles
config update
```


### Get vim(neovim) plugins in order
Refer to this page on how to install the plugin manager:

https://github.com/junegunn/vim-plug

Then open a shell and run the following to install the plugins
```sh
vim +PlugInstall
```

### Usage

```bash
config status
config add .vimrc
config commit -m "Add vimrc"
config add .config/redshift.conf
config commit -m "Add redshift config"
config push
```

### Repo created using
```bash
git init --bare $HOME/.dotfiles
```
