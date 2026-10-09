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
