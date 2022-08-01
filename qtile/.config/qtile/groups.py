from libqtile.config import Click, Drag, Group, Key, ScratchPad, DropDown
from libqtile.lazy import lazy

mod = "mod4"

def get_groups():
    return [Group(i) for i in "1234567890"]

def get_keys(groups):
    keys = []
    for i in groups:
        keys.extend([
            # mod1 + letter of group = switch to group
            Key(
                [mod],
                i.name,
                lazy.group[i.name].toscreen(),
                desc="Switch to group {}".format(i.name),
            ),
            # mod1 + shift + letter of group = switch to & move focused window to group
            Key(
                [mod, "control"],
                i.name,
                lazy.window.togroup(i.name, switch_group=True),
                desc="Switch to & move focused window to group {}".format(i.name),
            ),
            Key(
                [mod, "shift"],
                i.name,
                lazy.window.togroup(i.name, switch_group=False),
                desc="Switch to & move focused window to group {}".format(i.name),
            ),
            # Or, use below if you prefer not to switch to that group.
            # # mod1 + shift + letter of group = move focused window to group
            # Key([mod, "shift"], i.name, lazy.window.togroup(i.name),
            #     desc="move focused window to group {}".format(i.name)),
        ])

    return keys

def get_scratchpad_groups():
    return [
        ScratchPad("scratchpad", [
            # define a drop down terminal.
            # it is placed in the upper third of screen by default.
            DropDown(
                "term",
                "alacritty",
                opacity = 1,
                height = 0.5,
                width = 0.99,
                x = 0.005,
            ),
        ]),
    ]

def get_mouse():
# Drag floating layouts.
    return [
        Drag([mod], "Button1", lazy.window.set_position_floating(), start=lazy.window.get_position()),
        Drag([mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()),
        Click([mod], "Button2", lazy.window.bring_to_front()),
    ]

