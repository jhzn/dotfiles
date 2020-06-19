### 1st time Setup

```bash
curl https://raw.githubusercontent.com/jhzn/dotfiles/master/.config/dotfiles/bootstrap_dotfiles.sh > bootstrap.sh
chmod +x bootstrap.sh
#Open and modify file, because file is not usable per default
./bootstrap.sh
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
