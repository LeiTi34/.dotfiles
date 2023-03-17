local lualine = require('lualine')
if not lualine then return end

lualine.setup({
    options = {
        theme = 'kanagawa',
        globalstatus = true,
        -- component_separators = { left = '|', right = '|' },
        -- section_separators = { left = '', right = '' },
    },
    sections = {
        -- lualine_a = {
        --     { 'mode', separator = { left = '' }, right_padding = 2 },
        -- },
		lualine_c = { 'filename' },
        lualine_x = { 'overseer', 'encoding', 'filetype' },
        -- lualine_z = {
        --     { 'location', separator = { right = '' }, left_padding = 2 },
        -- },
	},
})
