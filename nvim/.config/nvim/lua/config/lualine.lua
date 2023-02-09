local lualine = require('lualine')
if not lualine then return end

local navic = require("nvim-navic")

lualine.setup({
    options = {
        theme = 'onedark',
        globalstatus = true,
    },
    sections = {
		lualine_c = { 'filename', 'lsp_progress' },
        lualine_x = { 'overseer', 'encoding', 'filetype' },
	},
    winbar = {
        lualine_c = {
            {navic.get_location, cond = navic.is_available }
        },
    },
})
