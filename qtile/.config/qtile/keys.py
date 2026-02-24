import os
from libqtile.config import Key
from libqtile.lazy import lazy

mod = "mod4"
terminal = "ghostty"

home = os.path.expanduser("~")
scripts = home + '/.scripts/'

def get_keys():
    return [
        # A list of available commands that can be bound to keys can be found
        # at https://docs.qtile.org/en/latest/manual/config/lazy.html
        # Switch between windows
        Key([mod], "h", lazy.layout.left(), desc="Move focus to left"),
        Key([mod], "l", lazy.layout.right(), desc="Move focus to right"),
        Key([mod], "j", lazy.layout.down(), desc="Move focus down"),
        Key([mod], "k", lazy.layout.up(), desc="Move focus up"),
        Key([mod], "space", lazy.layout.next(), desc="Move window focus to other window"),
        Key([mod, "shift"], "space", lazy.layout.flip()),
        # Move windows between left/right columns or move up/down in current stack.
        # Moving out of range in Columns layout will create new column.
        Key([mod, "shift"], "h", lazy.layout.swap_left(), lazy.layout.move_left()),
        Key([mod, "shift"], "l", lazy.layout.swap_right(), lazy.layout.move_right()),
        # Key([mod, "shift"], "h", lazy.layout.shuffle_left(), desc="Move window to the left"),
        # Key([mod, "shift"], "l", lazy.layout.shuffle_right(), desc="Move window to the right"),
        Key([mod, "shift"], "j", lazy.layout.shuffle_down(), lazy.layout.move_down(), desc="Move window down"),
        Key([mod, "shift"], "k", lazy.layout.shuffle_up(), lazy.layout.move_up(), desc="Move window up"),
        # Grow windows. If current window is on the edge of screen and direction
        # will be to screen edge - window would shrink.
        Key([mod, "control"], "h", lazy.layout.grow_left(), desc="Grow window to the left"),
        Key([mod, "control"], "l", lazy.layout.grow_right(), desc="Grow window to the right"),
        Key([mod, "control"], "j", lazy.layout.grow_down(), desc="Grow window down"),
        Key([mod, "control"], "k", lazy.layout.grow_up(), desc="Grow window up"),
        Key([mod], "n", lazy.layout.normalize(), desc="Reset all window sizes"),
        Key([mod], "o", lazy.layout.grow()),
        Key([mod], "i", lazy.layout.shrink()),
        Key([mod], "m", lazy.layout.maximize()),

        ### Switch focus to specific monitor (out of three)
        Key([mod], "w", lazy.to_screen(0), desc='Keyboard focus to monitor 1'),
        Key([mod], "e", lazy.to_screen(1), desc='Keyboard focus to monitor 2'),
        Key([mod], "r", lazy.to_screen(2), desc='Keyboard focus to monitor 3'),
        ### Switch focus of monitors
        Key([mod], "period", lazy.next_screen(), desc='Move focus to next monitor'),
        Key([mod], "comma", lazy.prev_screen(), desc='Move focus to prev monitor'),

        # Toggle between split and unsplit sides of stack.
        # Split = all windows displayed
        # Unsplit = 1 window displayed, like Max layout, but still with
        # multiple stack panes
        Key(
            [mod, "shift"],
            "Return",
            lazy.layout.toggle_split(),
            desc="Toggle between split and unsplit sides of stack",
        ),
        Key([mod], "Return", lazy.spawn(terminal), desc="Launch terminal"),
        # Toggle between different layouts as defined below
        Key([mod], "Tab", lazy.next_layout(), desc="Toggle between layouts"),
        Key([mod, "shift"], "c", lazy.window.kill(), desc="Kill focused window"),
        Key([mod, "shift"], "r", lazy.reload_config(), desc="Reload the config"),
        Key([mod, "shift"], "q", lazy.shutdown(), desc="Shutdown Qtile"),
        Key([mod, "shift"], "p", lazy.spawncmd(), desc="Spawn a command using a prompt widget"),
        Key([mod], "p", lazy.spawn('dmenu_run -fn Hack-10 -nb "#161417" -nf "#f7faf3" -sb "#59795f" -sf "#f7faf3"'), desc="Spawn a command using dmenu"),
        Key([mod], "b", lazy.window.toggle_fullscreen(), desc="Toggle fullscreen"),
        Key([mod], "t", lazy.window.toggle_floating(), desc="Toggle floating"),

        # Media Keys
        Key([], "XF86AudioMute", lazy.spawn("pulsemixer --toggle-mute"), desc="Mute/Unmute"),
        Key([], "XF86AudioLowerVolume", lazy.spawn("pulsemixer --change-volume -5"), desc="Lower Volume"),
        Key([], "XF86AudioRaiseVolume", lazy.spawn("pulsemixer --change-volume +5"), desc="Raise Volume"),
        Key([], "XF86AudioPlay", lazy.spawn("playerctl play-pause"), desc="Play/Pause"),
        Key([], "XF86AudioPrev", lazy.spawn("playerctl previous"), desc="Previous Track"),
        Key([], "XF86AudioNext", lazy.spawn("playerctl next"), desc="Next Track"),
        Key([], "XF86AudioRewind", lazy.spawn(scripts + "rewind-audio.sh"), desc="Rewind Audio"),
        # Mute Microphone
        #Key([], "XF86AudioMicMute", lazy.spawn("pulsemixer --toggle-mute-microphone"), desc="Mute/Unmute Microphone"),
        Key([], "XF86AudioMicMute", lazy.spawn("pamixer --default-source -t"), desc="Mute/Unmute Microphone"),
        # Brightness Keys
        Key([], "XF86MonBrightnessDown", lazy.spawn("light -U 10"), desc="Lower Monitor Brightness"),
        Key([], "XF86MonBrightnessUp", lazy.spawn("light -A 10"), desc="Raise Monitor Brightness"),

        # Take a screenshot
        Key([mod, "shift"], "s", lazy.spawn("scrot " + home + "'/Pictures/screenshots/%Y-%m-%d_$wx$h_scrot.png' -s -f -e 'xclip -selection clipboard -t image/png -i $f'"), desc="Take a screenshot"),

        # ScratchPad
        Key([mod], "s", lazy.group["scratchpad"].dropdown_toggle("term")),
    ]

