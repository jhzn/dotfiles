#this file is used by both bash and zsh
export EDITOR="nvim"
export READER="zathura"
export VISUAL="nvim"
export CODEEDITOR="vscodium"
export TERMINAL="alacritty"
export BROWSER="firefox"
export COLORTERM="truecolor"
export PAGER="less"
#export WM="bspwm"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"

export PICTURES="$HOME/Pictures"
export DOCUMENTS="$HOME/Documents"

export FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS'
--color=dark
--color=fg:-1,bg:-1,hl:#c678dd,fg+:#ffffff,bg+:#4b5263,hl+:#d858fe
--color=info:#98c379,prompt:#61afef,pointer:#be5046,marker:#e5c07b,spinner:#61afef,header:#61afef
'

export MONITOR_LAYOUT_FILE="$HOME/.cache/monitorlayout"
#Enables hardware decoding and wayland as compositor
export WAYLAND_CHROMIUM_FLAGS="--enable-features=VaapiVideoDecoder --enable-features=UseOzonePlatform --ozone-platform=wayland"
#export YT_DL_FORMAT="(bestvideo[height<=1080]+bestaudio)[ext=mp4]/bestvideo[height<=1080]+bestaudio/best[height<=1080]/bestvideo+bestaudio/best"
export YT_DL_FORMAT="bestvideo[vcodec^=avc1]+bestaudio[ext=m4a]"
export YTFZF_PREF="$YT_DL_FORMAT"

PATH=~/bin:$PATH
PATH=~/bin/scripts:$PATH
PATH=~/bin/scripts/emoji_finder.sh:$PATH
PATH=~/bin/scripts/vimv:$PATH
PATH=/usr/share/sway/scripts:$PATH

export GOPATH=~/go
export GOBIN=~/go/bin
PATH=~/go/bin:$PATH
PATH=~/.cargo/bin:$PATH
PATH=~/.yarn/bin:$PATH
PATH=~/.local/bin:$PATH
PATH=/usr/lib:$PATH
[ -f "$HOME/.cargo/env" ] && source "$HOME/.cargo/env"

# This is the list for lf icons:
# Taken from:
export LF_ICONS="di=📁:\
fi=📃:\
tw=🤝:\
ow=📂:\
ln=⛓:\
or=❌:\
ex=🎯:\
*.txt=✍:\
*.mom=✍:\
*.me=✍:\
*.ms=✍:\
*.png=🖼:\
*.webp=🖼:\
*.ico=🖼:\
*.jpg=📸:\
*.jpe=📸:\
*.jpeg=📸:\
*.gif=🖼:\
*.svg=🗺:\
*.tif=🖼:\
*.tiff=🖼:\
*.xcf=🖌:\
*.html=🌎:\
*.xml=📰:\
*.gpg=🔒:\
*.css=🎨:\
*.pdf=📚:\
*.djvu=📚:\
*.epub=📚:\
*.csv=📓:\
*.xlsx=📓:\
*.tex=📜:\
*.md=📘:\
*.r=📊:\
*.R=📊:\
*.rmd=📊:\
*.Rmd=📊:\
*.m=📊:\
*.mp3=🎵:\
*.opus=🎵:\
*.ogg=🎵:\
*.m4a=🎵:\
*.flac=🎼:\
*.wav=🎼:\
*.mkv=🎥:\
*.mp4=🎥:\
*.webm=🎥:\
*.mpeg=🎥:\
*.avi=🎥:\
*.mov=🎥:\
*.mpg=🎥:\
*.wmv=🎥:\
*.m4b=🎥:\
*.flv=🎥:\
*.zip=📦:\
*.rar=📦:\
*.7z=📦:\
*.tar.gz=📦:\
*.z64=🎮:\
*.v64=🎮:\
*.n64=🎮:\
*.gba=🎮:\
*.nes=🎮:\
*.gdi=🎮:\
*.1=ℹ:\
*.nfo=ℹ:\
*.info=ℹ:\
*.log=📙:\
*.iso=📀:\
*.img=📀:\
*.bib=🎓:\
*.ged=👪:\
*.part=💔:\
*.torrent=🔽:\
*.jar=♨:\
*.java=♨:\
"
