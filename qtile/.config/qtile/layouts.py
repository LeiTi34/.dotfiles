from libqtile import layout
from libqtile.config import Match

from themes import Themes

theme = Themes().get_theme('darkest')

layouts = [
    layout.MonadTall(
        border_focus=theme["green_soft"],
        border_normal=theme["bg_normal"],
        single_border_width=0,
    ),
    layout.Max(),
    layout.Columns(
        border_focus=theme["green_soft"],
        border_focus_stack=["purple_soft"],
        border_normal=theme["bg_normal"],
        border_normal_stack=theme["bg_dimmer"],
    ),
    # Try more layouts by unleashing below layouts.
    # layout.Stack(num_stacks=2),
    # layout.Bsp(),
    #layout.Matrix(),
    # layout.MonadWide(
    #     border_focus=theme["teal_soft"],
    #     border_normal=theme["bg_normal"],
    # ),
    # layout.RatioTile(
    #     border_focus=theme["teal_soft"],
    #     border_normal=theme["bg_normal"],
    # ),
    # layout.Tile(),
    layout.TreeTab(
        active_fg=theme["fg_normal"],
        active_bg=theme["green_soft"],
        bg_color=theme["bg_normal"],
        inactive_bg=theme["bg_dimmer"],
        inactive_fg=theme["fg_normal"],
        urgent_fg=theme["red_soft"],
        urgent_bg=theme["bg_dimmer"],
    ),
    # layout.VerticalTile(),
    layout.Zoomy(
        border_focus=theme["green_soft"],
        border_normal=theme["bg_normal"],
    ),
]

floating_layout = layout.Floating(
    border_focus=theme["green_soft"],
    border_normal=theme["bg_normal"],
    border_width=2,
    float_rules=[
        # Run the utility of `xprop` to see the wm class and name of an X client.
        *layout.Floating.default_float_rules,
        Match(wm_class="confirmreset"),  # gitk
        Match(wm_class="makebranch"),  # gitk
        Match(wm_class="maketag"),  # gitk
        Match(wm_class="ssh-askpass"),  # ssh-askpass
        Match(title="branchdialog"),  # gitk
        Match(title="pinentry"),  # GPG key password entry
    ]
)
