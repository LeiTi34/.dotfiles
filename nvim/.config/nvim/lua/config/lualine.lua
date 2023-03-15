local lualine = require('lualine')
if not lualine then return end

lualine.setup({
    options = {
        theme = 'kanagawa',
        globalstatus = true,
    },
    sections = {
		lualine_c = { 'filename' },
        lualine_x = { 'overseer', 'encoding', 'filetype' },
	},
})
