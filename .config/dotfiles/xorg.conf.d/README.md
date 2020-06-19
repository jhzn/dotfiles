Use these files to configure X as needed

```bash
#create dir if not existing
mkdir -p /etc/X11/xorg.conf.d

#copy files to correct location
#see the following man page for possible locations
man xorg.conf
cp ~/.config/dotfiles/xorg.conf.d/*.conf /etc/X11/xorg.conf.d
```
