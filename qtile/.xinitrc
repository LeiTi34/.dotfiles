#!/bin/sh

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi

if test -z "$DBUS_SESSION_BUS_ADDRESS"; then
	eval $(dbus-launch --exit-with-session --sh-syntax)
fi
systemctl --user import-environment DISPLAY XAUTHORITY

if command -v dbus-update-activation-environment >/dev/null 2>&1; then
        dbus-update-activation-environment DISPLAY XAUTHORITY
fi

# Swap ESC with Caps
#setxkbmap -option caps:swapescape
 #[ -f ~/.Xmodmap ] && xmodmap ~/.Xmodmap

setxkbmap de

# gnome-keyring
eval $(/usr/bin/gnome-keyring-daemon --login --components=pkcs11,secrets,ssh)
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
elif [ $(</etc/hostname) =  "PCNX-LeiAle1" ]; then
    # sreen orientation
    xrandr --output DP-2 --primary --auto
    xrandr --output DP-4 --left-of DP-2 --auto
    xrandr --output DP-0 --right-of DP-2 --auto
    # bg
    feh --bg-fill "$XDG_CONFIG_HOME/qtile/wallpaper.jpg" &
    # Keymap
    exec setxkbmap de &
fi


## auto mount disks
#exec udiskie &

# Compositor
exec picom &

# Bar
#exec polybar white &
#exec /home/alex/.config/polybar/launch.sh

## background
# feh --bg-scale $HOME/.wallpaper.png
#
#exec nextcloud &
#exec nm-applet &

# leftwm
#exec dbus-launch leftwm

# bspwm
#exec bspwm 

# xmonad
#exec xmonad
exec qtile start

#exec srandrd /home/alex/Scripts/monitor-hook.sh
#exec forever start /home/alex/shell-bot/server.js
