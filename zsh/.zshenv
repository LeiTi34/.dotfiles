# Github Web Login
export GCM_CREDENTIAL_STORE=secretservice

# Default editor
export EDITOR=/usr/bin/nvim

# XDG Dirs
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"

# System specific configuration
if [ $(</etc/hostname) =  "X1C6" ]; then
    export WIFI_INTERFACE="wlp2s0"
    export NETWORK_INTERFACE="enp0s31f6"
elif [ $(</etc/hostname) =  "840G6" ]; then
    export WIFI_INTERFACE="wlan0"
    export NETWORK_INTERFACE="enp0s31f6"
elif [ $(</etc/hostname) =  "TR" ]; then
    export WIFI_INTERFACE="tbd"
    export NETWORK_INTERFACE="tbd"
else
    export WIFI_INTERFACE="wlan0"
    export NETWORK_INTERFACE="eth0"
fi
