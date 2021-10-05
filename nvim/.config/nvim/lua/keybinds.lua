local map = vim.api.nvim_set_keymap

options = { noremap = true, silent = true }

-- Set up <Space> to be the global leader
map('n', '<Space>', '<NOP>', options)
vim.g.mapleader = ' '

-- Terminal
map('t', '<esc>', [[<C-\><C-n>]], options)
map('t', [[<C-v><esc>]], '<esc>', options)

-- Toggleterm
map("n", "<leader>lg", "<cmd>lua _lazygit_toggle()<CR>", options)

-- Telescope
map('n', '<Leader>ff', '<Cmd>lua require(\'telescope.builtin\').find_files()<CR>', options)
map('n', '<Leader>fg', '<Cmd>lua require(\'telescope.builtin\').live_grep()<CR>', options)
map('n', '<Leader>fb', '<Cmd>lua require(\'telescope.builtin\').buffers()<CR>', options)
map('n', '<Leader>fh', '<Cmd>lua require(\'telescope.builtin\').help_tags()<CR>', options)

-- CHADTree
map('n', '<Leader>n', '<Cmd>CHADopen<CR>', options)

-- Fugitive
map('n', '<Leader>gl', '<Cmd>:diffget //3<CR>', { noremap = true })
map('n', '<Leader>gh', '<Cmd>:diffget //2<CR>', { noremap = true })
map('n', '<Leader>gs', '<Cmd>:G<CR>', { noremap = true })
 
-- Focus
map('n', '<Leader>h', ':FocusSplitLeft<CR>', { silent = true })
map('n', '<Leader>j', ':FocusSplitDown<CR>', { silent = true })
map('n', '<Leader>k', ':FocusSplitUp<CR>', { silent = true })
map('n', '<Leader>l', ':FocusSplitRight<CR>', { silent = true })
-- map('n', '<Leader>nt', ':FocusSplitDown cmd term<CR>', { silent = true })

-- Bufferline
-- These commands will navigate through buffers in order regardless of which mode you are using
-- e.g. if you change the order of buffers :bnext and :bprevious will not respect the custom ordering
map('n', 'gb', ':BufferLineCycleNext<CR>', options)
map('n', 'gB', ':BufferLineCyclePrev<CR>', options)
-- These commands will move the current buffer backwards or forwards in the bufferline
map('n', 'g<C-b>', ':BufferLineMoveNext<CR>', options)
map('n', 'g<C-B>', ':BufferLineMovePrev<CR>', options)
-- These commands will sort buffers by directory, language, or a custom criteria
map('n', '<Leader>be', ':BufferLineSortByExtension<CR>', options)
map('n', '<Leader>bd', ':BufferLineSortByDirectory<CR>', options)

-- LSP
-- See `:help vim.lsp.*` for documentation on any of the below functions
map("n", "<Leader>oi", ":TSLspOrganize<CR>", options)
map("n", "<Leader>rf", ":TSLspRenameFile<CR>", options)
map("n", "<Leader>ia", ":TSLspImportAll<CR>", options)
map('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', options)
map('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', options)
map('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', options)
map('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', options)
map('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', options)
map('n', '<Leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', options)
map('n', '<Leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', options)
map('n', '<Leader>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', options)
map('n', '<Leader>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', options)
map('n', '<Leader>rr', '<cmd>lua vim.lsp.buf.rename()<CR>', options)
-- map('n', '<Leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', options)
map('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', options)
map('n', '<Leader>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', options)
map('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', options)
map('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', options)
map('n', '<Leader>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', options)
map('n', '<Leader>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', options)

-- Code Action Menu
map('n', '<Leader>ca', '<cmd>CodeActionMenu<CR>', options)

-- Dadbod UI
map('n', '<Leader>du', '<cmd>:DBUIToggle<CR>', options)
map('n', '<Leader>df', '<cmd>:DBUIFindBuffer<CR>', options)
map('n', '<Leader>dr', '<cmd>:DBUIRenameBuffer<CR>', options)
map('n', '<Leader>dl', '<cmd>:DBUILastQueryInfo<CR>', options)
