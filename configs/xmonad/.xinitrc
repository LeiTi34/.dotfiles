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


# Device specific config
if [ $(</etc/hostname) =  "TR" ]; then
    # sreen orientation
    xrandr --output DP-2 --right-of HDMI-0 --auto --primary &
    # RGB
    liquidctl set led color fixed "rgb(0, 255, 255)"
    # Keymap
    exec setxkbmap de &
fi


# auto mount disks
exec udiskie &

# Compositor
exec picom &

# Bar
#exec polybar white &
#exec /home/alex/.config/polybar/launch.sh

# background
feh --bg-scale $HOME/.wallpaper.png

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
