local lualine = require('lualine')
if not lualine then return end

lualine.setup({
    options = {
        theme = 'onedark',
        globalstatus = true,
    }
})
