---@module 'hl'

hl.monitor({
    output   = "",
    mode     = "preferred",
    position = "auto",
    scale    = 1,
})

-- exec-once = kanshi
hl.config({
    debug = {
        disable_logs = false,
    },
    xwayland = {
        force_zero_scaling = true,
    },
    misc = {
        vrr = 1,
        disable_hyprland_logo = true,
        disable_splash_rendering = true,
    },
    input = {
        kb_layout = "de",
        kb_variant = "",
        kb_model = "",
        kb_options = "",
        kb_rules = "",
        follow_mouse = 1,
        touchpad = {
            natural_scroll = true,
        },
        sensitivity = 0,
    },
    general = {
        gaps_in = 2,
        gaps_out = 5,
        border_size = 2,
        col = {
            active_border = {
                colors = {
                    "rgba(33ccffee)", "rgba(00ff99ee)",
                },
                angle = 45,
            },
            inactive_border = "rgba(595959aa)",
        },
        layout = "master",
    },
    decoration = {
        rounding = 10,
        -- blur = yes
        -- blur_size = 3
        -- blur_passes = 1
        -- blur_new_optimizations = on
        -- drop_shadow = yes
        -- shadow_range = 4
        -- shadow_render_power = 3
        -- col.shadow = rgba(1a1a1aee)
        blur = {
            enabled = false,
            size = 3,
            passes = 1,
            new_optimizations = true,
        },
        shadow = {
            enabled = false,
            range = 8,
            render_power = 3,
            color = "0xee1a1a1a",
        },
    },
    dwindle = {
        preserve_split = true,
    },
    gestures = {
        workspace_swipe_distance = 400,
        workspace_swipe_cancel_ratio = 0.2,
    },
})

hl.curve("myBezier", {
    type = "bezier",
    points = {{ 0.05, 0.9 }, {0.1, 1.05}},
})

hl.animation({
    leaf = "windows",
    enabled = true,
    speed = 2,
    bezier = "myBezier",
})
hl.animation({
    leaf = "windowsOut",
    enabled = true,
    speed = 2,
    bezier = "default",
    style = "popin 80%"
})
hl.animation({
    leaf = "border",
    enabled = true,
    speed = 10,
    bezier = "default",
})
hl.animation({
    leaf = "borderangle",
    enabled = true,
    speed = 8,
    bezier = "default",
})
hl.animation({
    leaf = "fade",
    enabled = true,
    speed = 2,
    bezier = "default",
})
hl.animation({
    leaf = "workspaces",
    enabled = true,
    speed = 3,
    bezier = "default",
})

hl.gesture({
   fingers = 3,
   direction = "horizontal",
   action = "workspace"
})
hl.gesture({
   fingers = 3,
   direction = "vertical",
   action = "fullscreen"
})

hl.window_rule({
    name  = "opacity_0_0_override",
    match = {
        class = "^(xwaylandvideobridge)$",
    },
    opacity = "0.0 override",
})
hl.window_rule({
    name  = "no_anim_on",
    match = {
        class = "^(xwaylandvideobridge)$",
    },
    no_anim = true,
})
hl.window_rule({
    name  = "no_initial_focus_on",
    match = {
        class = "^(xwaylandvideobridge)$",
    },
    no_initial_focus = true,
})
hl.window_rule({
    name  = "max_size_1_1",
    match = {
        class = "^(xwaylandvideobridge)$",
    },
    max_size = { 1, 1 },
})
hl.window_rule({
    name  = "no_blur_on",
    match = {
        class = "^(xwaylandvideobridge)$",
    },
    no_blur = true,
})
hl.window_rule({
    name  = "no_focus_on",
    match = {
        class = "^(xwaylandvideobridge)$",
    },
    no_focus = true,
})

--# No Gaps for single window on workspace


hl.workspace_rule({
    workspace = "w[tv1]",
    gaps_out = 0,
    gaps_in = 0,
    no_shadow = true,
})
hl.workspace_rule({
    workspace = "f[1]",
    gaps_out = 0,
    gaps_in = 0,
    no_shadow = true,
})

hl.window_rule({
    match = {
        workspace = "w[tv1]",
        float = false,
    },
    border_size = 0,
    rounding = 0,
})
hl.window_rule({
    match = {
        workspace = "f[1]",
        float = false,
    },
    border_size = 0,
    rounding = 0,
})

local mainMod = "SUPER"

hl.bind(mainMod .. " + " .. "SHIFT" .. " + " .. "c", hl.dsp.window.close())
hl.bind(mainMod .. " + " .. "SHIFT" .. " + " .. "q", hl.dsp.exit())
hl.bind(mainMod .. " + " .. "t", hl.dsp.window.float())
hl.bind(mainMod .. " + " .. "p", hl.dsp.exec_cmd("bemenu-run"))
hl.bind(mainMod .. " + " .. "SHIFT" .. " + " .. "p", hl.dsp.exec_cmd("fuzzel"))
hl.bind(mainMod .. " + " .. "return", hl.dsp.exec_cmd("alacritty"))
hl.bind(mainMod .. " + " .. "b", hl.dsp.window.fullscreen())
hl.bind(mainMod .. " + " .. "j", hl.dsp.layout("cyclenext"))
hl.bind(mainMod .. " + " .. "k", hl.dsp.layout("cycleprev"))
hl.bind(mainMod .. " + " .. "SHIFT" .. " + " .. "h", hl.dsp.layout("swapwithmaster"))
hl.bind(mainMod .. " + " .. "SHIFT" .. " + " .. "k", hl.dsp.layout("swapprev"))
hl.bind(mainMod .. " + " .. "SHIFT" .. " + " .. "j", hl.dsp.layout("swapnext"))

for i = 1, 10 do
    -- Switch workspaces with mainMod + [0-9]
    hl.bind(mainMod .. " + " .. i % 10, hl.dsp.focus({ workspace = i, on_current_monitor = true }))
    -- Move active window to a workspace with mainMod + SHIFT + [0-9]
    hl.bind(mainMod .. " + " .. "SHIFT" .. " + " .. i % 10, hl.dsp.window.move({ workspace = i, follow = false }))
end

-- Scroll through existing workspaces with mainMod + scroll

hl.bind(mainMod .. " + " .. "mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + " .. "mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging

hl.bind(mainMod .. " + " .. "mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + " .. "mouse:273", hl.dsp.window.resize(), { mouse = true })

hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), { locked = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("pamixer --default-source -t"), { locked = true })

-- Requires playerctl

hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })

hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("light -U 10"), { locked = true })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("light -A 10"), { locked = true })

hl.bind(mainMod .. " + " .. "SHIFT" .. " + " .. "s", hl.dsp.exec_cmd("grimblast --freeze copysave area ~/Pictures/screenshots/$(date +%Y-%m-%d_%H-%m-%s).png"))


hl.on("hyprland.start", function()
    hl.exec_cmd("systemctl --user start hyprpolkitagent")
    hl.exec_cmd("dms run")
    hl.exec_cmd("nextcloud --background")
    hl.exec_cmd("nm-applet")
    hl.exec_cmd("wl-paste --type text --watch cliphist store")
    hl.exec_cmd("wl-paste --type image --watch cliphist store")
end)
