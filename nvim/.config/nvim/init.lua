-- Get path to my lua config files
local config = vim.fn['stdpath']('config')..'/lua/'

-- I use dofile instead of require so I can reload my settings without closing
-- and reopening NeoVim
dofile(config..'keybinds.lua')
dofile(config..'settings.lua')

-- Plugin Shenanigans
dofile(config..'plugins.lua')

dofile(config..'pluginSettings/treesitter.lua')
dofile(config..'pluginSettings/feline.lua')
dofile(config..'pluginSettings/bufferline.lua')
dofile(config..'pluginSettings/github-theme.lua')
dofile(config..'pluginSettings/coq.lua')
dofile(config..'pluginSettings/lspconfig.lua')
dofile(config..'pluginSettings/toggleterm.lua')
-- dofile(config..'pluginSettings/focus.lua')
