vim.opt.termguicolors = true
require("bufferline").setup{
    options = {
        diagnostics = 'nvim_lsp',
        offsets = {{ filetype = 'CHADTree', text = 'CHADTree'}} 
    }
}
