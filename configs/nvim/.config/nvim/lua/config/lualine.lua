local lualine = require('lualine')
if not lualine then return end

lualine.setup({
    options = {
        theme = 'kanagawa',
        globalstatus = true,
        component_separators = "|",
		section_separators = { left = "", right = "" },
    },
    sections = {
        lualine_a = {
            { "mode", separator = { left = "", right = "" } }
        },
        -- lualine_a = {
        --     { 'mode', separator = { left = '' }, right_padding = 2 },
        -- },
		-- lualine_c = { 'filename' },
		lualine_b = { "filename", "branch", "diff", "diagnostics" },
        lualine_c = {},
        lualine_x = {},
        lualine_y = { 'overseer', 'encoding', 'filetype' },
        lualine_z = { { "location", separator = { left = "", right = "" } } },
        -- lualine_z = {
        --     { 'location', separator = { right = '' }, left_padding = 2 },
        -- },
	},
})
