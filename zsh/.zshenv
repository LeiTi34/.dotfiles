# Github Web Login
export GCM_CREDENTIAL_STORE=secretservice

# Default editor
export EDITOR=/usr/bin/nvim

# Wayland
export XKB_DEFAULT_LAYOUT=de
export GTK_THEME="Adwaita-dark"

# XDG Dirs
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"

# System specific configuration
if [ $(</etc/hostname) =  "X1C6" ]; then
    export WLAN_INTERFACE="wlp2s0"
    export NETWORK_INTERFACE="enp0s31f6"
elif [ $(</etc/hostname) =  "840G6" ]; then
    export WLAN_INTERFACE="wlan0"
    export NETWORK_INTERFACE="enp0s31f6"
elif [ $(</etc/hostname) =  "TR" ]; then
    export WLAN_INTERFACE="wlp5s0"
    export NETWORK_INTERFACE="enp8s0"
    export WLR_NO_HARDWARE_CURSORS=1 # Fix mouse courser not shown in wlroots
else
    export WLAN_INTERFACE="wlan0"
    export NETWORK_INTERFACE="eth0"
fi
