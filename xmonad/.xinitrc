#!/bin/sh

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi

# Swap ESC with Caps
#setxkbmap -option caps:swapescape
 #[ -f ~/.Xmodmap ] && xmodmap ~/.Xmodmap

# gnome-keyring
eval $(/usr/bin/gnome-keyring-daemon --start --components=pkcs11,secrets,ssh)
export SSH_AUTH_SOCK

# Dotnet Core
#export PATH="$PATH:/home/user/.dotnet/tools"
# Android Studio / JetBrains
export _JAVA_AWT_WM_NONREPARENTING=1
# Alacritty no DPI scale
export WINIT_X11_SCALE_FACTOR=1

# XDG Dirs
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"

export EDITOR=/usr/bin/nvim

# auto mount disks
exec udiskie &

# Compositor
exec picom &

# Bar
#exec polybar white &
#exec /home/alex/.config/polybar/launch.sh

# background
feh --bg-scale /home/alex/Bilder/Wallpaper.png &

exec nextcloud &
exec nm-applet &

# leftwm
#exec dbus-launch leftwm

# bspwm
#exec bspwm 

# xmonad
exec xmonad

#exec srandrd /home/alex/Scripts/monitor-hook.sh
#exec forever start /home/alex/shell-bot/server.js
