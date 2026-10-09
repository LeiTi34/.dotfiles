---@module 'hl'

hl.monitor({
    output   = "HDMI-A-1",
    mode     = "preferred",
    position = "0x0",
    scale    = 1,
})
hl.monitor({
    output   = "DP-3",
    mode     = "2560x1440@144",
    position = "1920x0",
    scale    = 1,
    vrr      = 3,
})
