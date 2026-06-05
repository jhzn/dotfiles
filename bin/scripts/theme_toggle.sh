#!/bin/bash

source ~/.config/dotfiles/bash_strict_mode.sh

alacritty_theme() {
	touch ~/.config/alacritty/theme.yml
	cat "$HOME/.config/alacritty/$1.toml" > ~/.config/alacritty/theme.toml
}
nvim_theme() {
	echo 'vim.g.theme_style = "'$1'"' > ~/.config/nvim/lua/theme.lua
}
delta_theme() {
	git config --global delta.syntax-theme "$1"
	if [[ "$1" == "OneHalfLight" ]]; then
		git config --global delta.dark "false"
		git config --global delta.light "true"
		return
	fi
	git config --global delta.dark "true"
	git config --global delta.light "false"
}
tmux_theme() {
	theme_file=~/.cache/tmux_theme
	if [ "$1" == "light" ]; then
		cfg=$(cat <<- EOF
			# Light theme
			export onedark_background="#fafafa"
			export onedark_comment_grey="#f0f0f0"
			export onedark_foreground="#101012"
			export onedark_highlights="#dcdcdc"
			EOF
		)
		echo "$cfg" > "$theme_file"
	else
		echo "unset onedark_background onedark_comment_grey onedark_foreground onedark_highlights" > "$theme_file"
	fi
}

glow_theme() {
	theme_file=~/.config/glow/glow.yml
	defaults_theme_file=~/.config/glow/defaults.yml
	touch $theme_file
	cp $defaults_theme_file $theme_file
	if [ "$1" == "light" ]; then
		echo 'style: "light"' >> $theme_file
	else
		echo 'style: "dark"' >> $theme_file
	fi
}
zsh_theme() {
	theme_file=~/.cache/zsh_theme
	cfg=$(cat <<- EOF
		# Light $1
		export ZSH_THEME=$1
		EOF
	)
	echo "$cfg" > "$theme_file"
}

k9s_theme() {
	templ_theme_file="$HOME/.config/k9s/skins/one_dark.templ.yaml"
	output_theme_file="$HOME/.config/k9s/skins/one_dark.yaml"
	if [ "$1" == "light" ]; then
		light=$(cat <<- EOF
			# Light theme
			foreground: &foreground "black"
			background: &background "#fafafa"
			EOF
		)
		cat <(echo "$light") "$templ_theme_file" > "$output_theme_file"
	else
		dark=$(cat <<- EOF
			# Dark theme
			foreground: &foreground "#abb2bf"
			background: &background "#282c34"
			EOF
		)
		cat <(echo "$dark") "$templ_theme_file" > "$output_theme_file"
	fi
}


dark_theme_name="dark"
light_theme_name="light"

current_theme_cache=~/.cache/current_theme.txt
touch "$current_theme_cache"
current_theme=$(< "$current_theme_cache")

set_dark_theme() {
	delta_theme "OneHalfDark"
	nvim_theme "darker"
	alacritty_theme "dark"
	tmux_theme "dark"
	glow_theme "dark"
	zsh_theme "dark"
	k9s_theme "dark"
	gsettings set org.gnome.desktop.interface gtk-theme 'Adapta-Nokto'
	printf "$dark_theme_name" > "$current_theme_cache"
	echo "Dark set!"
}

set_light_theme() {
	delta_theme "OneHalfLight"
	nvim_theme "light"
	alacritty_theme "light"
	tmux_theme "light"
	glow_theme "light"
	zsh_theme "light"
	k9s_theme "light"
	gsettings set org.gnome.desktop.interface gtk-theme 'Adapta'
	printf "$light_theme_name" > "$current_theme_cache"
	echo "Light set!"
}

# Default theme is dark
if [ -z "$current_theme" ]; then
	set_dark_theme
	exit 0
fi

# This acts like a toggle between the themes
if [ "$current_theme" == "$dark_theme_name" ]; then
	set_light_theme
else
	set_dark_theme
fi

