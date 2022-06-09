import os
import psutil
from libqtile import bar, widget, qtile
from libqtile.config import Screen

from themes import Themes

theme = Themes().get_theme('darkest')


widget_defaults = dict(
    font="Hack",
    fontsize=13,
    padding=3,
    foreground=theme["fg_normal"],
)
extension_defaults = widget_defaults.copy()

def get_widgets(type="primary"):
    widgets = [
        widget.CurrentLayoutIcon(
            scale = .75,
        ),
        widget.GroupBox(
            disable_drag=True,
            highlight_method="block",

            active=theme["fg_normal"],
            inactive=theme["bg_dimmer"],
            border=theme["green_soft"],
            other_screen_border=theme["bg_dimmer"], # TODO
            other_current_screen_border=theme["bg_dimmer"],
            this_current_screen_border=theme["green_soft"],
            this_screen_border=theme["blue_soft"],

            urgent_alert_method="border",
            urgent_border=theme["red_soft"],
            urgent_text=theme["fg_normal"],
        ),
        widget.Prompt(
            bell_style="visual",
            background=theme["bg_dim"],
        ),
        widget.WindowName(
            foreground=theme["teal_soft"],
        ),
        widget.Chord(
            chords_colors={
                "launch": ("#ff0000", "#ffffff"),
            },
            name_transform=lambda name: name.upper(),
        ),
        #widget.TextBox("default config", name="default"),
        #widget.TextBox("Press &lt;M-r&gt; to spawn", foreground="#d75f5f"),
        widget.Net(
            format=" {down}",
            foreground=theme["yellow_hard"],
        ),
        widget.Sep(
            foreground=theme["bg_dim"],
            linewidth=2,
            size_percent=100,
        ),
        widget.TextBox(
            fontsize=20,
            foreground=theme["blue_hard"],
            text ="龍",
        ),
        widget.CPU(
            format="{load_percent}%",
            foreground=theme["blue_hard"],
        ),
        widget.Sep(
            foreground=theme["bg_dim"],
            linewidth=2,
            size_percent=100,
        ),
        widget.Sep(
            linewidth=0,
            padding=5,
        ),
        widget.TextBox(
            fontsize=20,
            foreground=theme["blue_hard"],
            text ="",
            padding=0,
        ),
        widget.Memory(
            format="{MemUsed: .0f}{mm}",
            foreground=theme["blue_hard"],
            measure_mem="G",
            padding=0,
        )
    ]

    if psutil.sensors_battery() is not None:
        widgets.extend([
            widget.Sep(
                foreground=theme["bg_dim"],
                linewidth=2,
                size_percent=100,
            ),
            widget.Battery(
                font="Material Design Icons",
                fontsize=17,
                charge_char="",
                discharge_char="󰁾",
                full_char="󰁹",
                empty_char="󰂎",
                format="{char}",
                show_short_text=False,
                low_percentage=15,
                low_foreground=theme["red_soft"],
            ),
            widget.Battery(
                format="{percent:2.0%}",
                show_short_text=False,
                low_percentage=15,
                low_foreground=theme["red_soft"],
            )
        ])

    widgets.extend([
        widget.Sep(
            foreground=theme["bg_dim"],
            linewidth=2,
            size_percent=100,
        ),
        widget.TextBox(
            foreground=theme["red_hard"],
            fontsize=20,
            text ="ﮮ",
        ),
        widget.CheckUpdates(
            display_format="{updates}",
            foreground=theme["red_hard"],
            colour_have_updates=theme["red_hard"],
            colour_no_updates=theme["red_hard"],
            update_interval=300,
            no_update_string="0",
            execute="alacritty -e paru"
        ),
        widget.Sep(
            foreground=theme["bg_dim"],
            linewidth=2,
            size_percent=100,
        ),
        widget.TextBox(
            fontsize=20,
            foreground=theme["purple_hard"],
            text ="墳",
        ),
        # widget.PulseVolume(
        #     theme_path="~/.config/qtile/icons",
        #     foreground=theme["purple_hard"],
        #     font="Material Design Icons",
        #     emoji=True,
        #     volume_app="pavucontrol",
        #
        # ),
        widget.PulseVolume(
            fmt="{}",
            foreground=theme["purple_hard"],
            volume_app="pavucontrol",
        )
    ])

    backlight_path = "/sys/class/backlight/intel_backlight"

    if os.path.exists(backlight_path):
        widgets.extend([
            widget.Sep(
                foreground=theme["bg_dim"],
                linewidth=2,
                size_percent=100,
            ),
            widget.TextBox(
                fontsize=20,
                foreground=theme["purple_hard"],
                text ="",
            ),
            widget.Backlight(
                foreground=theme["purple_hard"],
                brightness_file = backlight_path + "/brightness",
                max_brightness_file = backlight_path + "/max_brightness",
                change_command="light -S {}",
            )
        ])

    if type == "primary":
        widgets.extend([
            widget.Sep(
                foreground=theme["bg_dim"],
                linewidth=2,
                size_percent=100,
            ),
            widget.StatusNotifier() if qtile.core.name == "wayland" else widget.Systray(),
            widget.Sep(
                foreground=theme["bg_dim"],
                linewidth=2,
                size_percent=100,
            )
        ])

    widgets.extend([
        widget.TextBox(
            fontsize=20,
            foreground=theme["green_hard"],
            text ="",
        ),
        widget.Clock(
            foreground=theme["green_hard"],
            format="%a %d.%m.%Y",
        ),
        widget.TextBox(
            foreground=theme["teal_hard"],
            fontsize=20,
            text ="",
        ),
        widget.Clock(
            foreground=theme["teal_hard"],
            format="%H:%M",
        ),
        #widget.QuickExit(),
    ])

    return widgets

def get_status_bar(type="primary"):
    return bar.Bar(
        get_widgets(type=type),
        24,
        background=theme["bg_normal"],
        # border_width=[2, 0, 2, 0],  # Draw top and bottom borders
        # border_color=["ff00ff", "000000", "ff00ff", "000000"]  # Borders are magenta
    )

def get_screen(type="primary"):
    return Screen(top=get_status_bar(type=type), wallpaper='~/.config/qtile/wallpaper.jpg', wallpaper_mode='fill')

screens = [get_screen()]

connected_monitors = 3

if connected_monitors > 1:
    for _ in range(1, connected_monitors):
        screens.append(get_screen(type="secondary"))
