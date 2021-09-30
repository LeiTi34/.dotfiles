-- Get path to my lua config files
local config = vim.fn['stdpath']('config')..'/lua/'

-- I use dofile instead of require so I can reload my settings without closing
-- and reopening NeoVim
dofile(config..'keybinds.lua')
dofile(config..'settings.lua')

-- Plugin Shenanigans
dofile(config..'plugins.lua')
