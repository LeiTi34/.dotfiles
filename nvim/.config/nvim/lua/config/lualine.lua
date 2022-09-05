local lualine = require('lualine')
if not lualine then return end

local navic = require("nvim-navic")

lualine.setup({
    options = {
        theme = 'leaf',
        globalstatus = true,
    },
    sections = {
		lualine_c = {
			'lsp_progress'
		},
	},
    winbar = {
        lualine_c = {
            {navic.get_location, cond = navic.is_available }
        },
    },
})
