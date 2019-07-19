### Setup

```bash
	#all we care about is the .git folder which is placed in ~/.dotfiles
	git clone --separate-git-dir=$HOME/.dotfiles https://github.com/jhzn/dotfiles $HOME/dotfiles-tmp && rm -rf dotfiles-tmp
	echo "alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'" >> ~/.bash_aliases && \
	source ~/.bash_aliases && \
	config config status.showUntrackedFiles no && echo "Successfully downloaded dotfiles and setup configuration. All that remains is to update .bashrc"
	
	#Update ~/.bashrc with dotfiles config
	echo "source ~/.config/dotfiles/bash_opts.sh" >> ~/.bashrc
	
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
