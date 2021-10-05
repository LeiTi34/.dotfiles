local map = vim.api.nvim_set_keymap

-- Set up <Space> to be the global leader
map('n', '<Space>', '<NOP>', { noremap = true, silent = true })
vim.g.mapleader = ' '

-- Terminal
map('t', '<esc>', [[<C-\><C-n>]], { noremap = true, silent = true })
map('t', [[<C-v><esc>]], '<esc>', { noremap = true, silent = true })

-- Toggleterm
map("n", "<leader>lg", "<cmd>lua _lazygit_toggle()<CR>", {noremap = true, silent = true})

-- Telescope
map('n', '<Leader>ff', '<Cmd>lua require(\'telescope.builtin\').find_files()<CR>', { noremap = true, silent = true })
map('n', '<Leader>fg', '<Cmd>lua require(\'telescope.builtin\').live_grep()<CR>', { noremap = true, silent = true })
map('n', '<Leader>fb', '<Cmd>lua require(\'telescope.builtin\').buffers()<CR>', { noremap = true, silent = true })
map('n', '<Leader>fh', '<Cmd>lua require(\'telescope.builtin\').help_tags()<CR>', { noremap = true, silent = true })

-- CHADTree
map('n', '<Leader>n', '<Cmd>CHADopen<CR>', { noremap = true, silent = true })

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
map('n', 'gb', ':BufferLineCycleNext<CR>', { noremap = true, silent = true })
map('n', 'gB', ':BufferLineCyclePrev<CR>', { noremap = true, silent = true })
-- These commands will move the current buffer backwards or forwards in the bufferline
map('n', 'g<C-b>', ':BufferLineMoveNext<CR>', { noremap = true, silent = true })
map('n', 'g<C-B>', ':BufferLineMovePrev<CR>', { noremap = true, silent = true })
-- These commands will sort buffers by directory, language, or a custom criteria
map('n', '<Leader>be', ':BufferLineSortByExtension<CR>', { noremap = true, silent = true })
map('n', '<Leader>bd', ':BufferLineSortByDirectory<CR>', { noremap = true, silent = true })

-- LSP
-- See `:help vim.lsp.*` for documentation on any of the below functions
map("n", "<Leader>oi", ":TSLspOrganize<CR>", { noremap = true, silent = true})
map("n", "<Leader>rf", ":TSLspRenameFile<CR>", { noremap = true, silent = true})
map("n", "<Leader>ia", ":TSLspImportAll<CR>", { noremap = true, silent = true})
map('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', { noremap = true, silent = true})
map('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', { noremap = true, silent = true})
map('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', { noremap = true, silent = true})
map('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', { noremap = true, silent = true})
map('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', { noremap = true, silent = true})
map('n', '<Leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', { noremap = true, silent = true})
map('n', '<Leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', { noremap = true, silent = true})
map('n', '<Leader>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', { noremap = true, silent = true})
map('n', '<Leader>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', { noremap = true, silent = true})
map('n', '<Leader>rr', '<cmd>lua vim.lsp.buf.rename()<CR>', { noremap = true, silent = true})
-- map('n', '<Leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', { noremap = true, silent = true})
map('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', { noremap = true, silent = true})
map('n', '<Leader>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', { noremap = true, silent = true})
map('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', { noremap = true, silent = true})
map('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', { noremap = true, silent = true})
map('n', '<Leader>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', { noremap = true, silent = true})
map('n', '<Leader>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', { noremap = true, silent = true})

-- Code Action Menu
map('n', '<Leader>ca', '<cmd>CodeActionMenu<CR>', { noremap = true, silent = true})

-- Dadbod UI
map('n', '<Leader>du', '<cmd>:DBUIToggle<CR>', { noremap = true, silent = true})
map('n', '<Leader>df', '<cmd>:DBUIFindBuffer<CR>', { noremap = true, silent = true})
map('n', '<Leader>dr', '<cmd>:DBUIRenameBuffer<CR>', { noremap = true, silent = true})
map('n', '<Leader>dl', '<cmd>:DBUILastQueryInfo<CR>', { noremap = true, silent = true})
