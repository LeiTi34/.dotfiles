vim.opt.termguicolors = true
local bufferline = require("bufferline")
if not bufferline then return end

bufferline.setup{
    options = {
        diagnostics = 'nvim_lsp',
        offsets = {{ filetype = 'CHADTree', text = 'CHADTree'}} 
    }
}
