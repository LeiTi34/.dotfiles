local theme = require("leaf")
if not theme then return end

theme.setup({
    theme = "darkest", -- default, alternatives: "dark", "lighter", "darker", "lightest", "darkest"
})

-- setup must be called before loading
vim.cmd("colorscheme leaf")
