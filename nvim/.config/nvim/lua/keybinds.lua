local map = vim.api.nvim_set_keymap

options = { noremap = true, silent = true }

-- Set up <Space> to be the global leader
map('n', '<Space>', '<NOP>', options)
vim.g.mapleader = ' '

-- Remaps
map('v', 'J', ':m \'>+1<CR>gv=gv', options)
map('v', 'K', ':m \'<-2<CR>gv=gv', options)

map('n', '<leader>h', ':wincmd h<CR>', options)
map('n', '<leader>j', ':wincmd j<CR>', options)
map('n', '<leader>k', ':wincmd k<CR>', options)
map('n', '<leader>l', ':wincmd l<CR>', options)

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
map('n', '<Leader>gl', '<Cmd>:diffget //3<CR>', options)
map('n', '<Leader>gh', '<Cmd>:diffget //2<CR>', options)

-- Neogit
map('n', '<Leader>gs', '<Cmd>lua require(\'neogit\').open()<CR>', options)
 
-- -- Focus
-- map('n', '<Leader>h', ':FocusSplitLeft<CR>', { silent = true })
-- map('n', '<Leader>j', ':FocusSplitDown<CR>', { silent = true })
-- map('n', '<Leader>k', ':FocusSplitUp<CR>', { silent = true })
-- map('n', '<Leader>l', ':FocusSplitRight<CR>', { silent = true })
-- -- map('n', '<Leader>nt', ':FocusSplitDown cmd term<CR>', { silent = true })

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
map('n', '<Leader>cA', '<cmd>lua vim.lsp.buf.code_action()<CR>', options)
map('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', options)
map('n', '<Leader>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', options)
map('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', options)
map('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', options)
map('n', '<Leader>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', options)
map('n', '<Leader>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', options)

-- Navigate quick fix list
map('n', '[q', '<cmd>cprev<CR>', options)
map('n', ']q', '<cmd>cnext<CR>', options)

-- Code Action Menu
map('n', '<Leader>ca', '<cmd>CodeActionMenu<CR>', options)

-- Dadbod UI
map('n', '<Leader>du', '<cmd>:DBUIToggle<CR>', options)
map('n', '<Leader>df', '<cmd>:DBUIFindBuffer<CR>', options)
map('n', '<Leader>dr', '<cmd>:DBUIRenameBuffer<CR>', options)
map('n', '<Leader>dl', '<cmd>:DBUILastQueryInfo<CR>', options)

-- Harpoon
map('n', '<leader>ha', ':lua require("harpoon.mark").add_file()<CR>', options)
map('n', '<leader>hm', ':lua require("harpoon.ui").toggle_quick_menu()<CR>', options)
map('n', '<leader>tm', ':lua require("harpoon.cmd-ui").toggle_quick_menu()<CR>', options)

map('n', '<C-h>', ':lua require("harpoon.ui").nav_file(1)<CR>', options)
map('n', '<C-j>', ':lua require("harpoon.ui").nav_file(2)<CR>', options)
map('n', '<C-k>', ':lua require("harpoon.ui").nav_file(3)<CR>', options)
map('n', '<C-l>', ':lua require("harpoon.ui").nav_file(4)<CR>', options)

map('n', '<leader>th', ':lua require("harpoon.term").gotoTerminal(1)<CR>', options)
map('n', '<leader>tj', ':lua require("harpoon.term").gotoTerminal(2)<CR>', options)
map('n', '<leader>tk', ':lua require("harpoon.term").gotoTerminal(3)<CR>', options)
map('n', '<leader>tl', ':lua require("harpoon.term").gotoTerminal(4)<CR>', options)
map('n', '<leader>ch', ':lua require("harpoon.term").sendCommand(1, 1)<CR>', options)
map('n', '<leader>cj', ':lua require("harpoon.term").sendCommand(1, 2)<CR>', options)
map('n', '<leader>ck', ':lua require("harpoon.term").sendCommand(1, 3)<CR>', options)
map('n', '<leader>cl', ':lua require("harpoon.term").sendCommand(1, 3)<CR>', options)

-- Git Worktree
map('n', '<leader>ww', ':lua require("telescope").extensions.git_worktree.git_worktrees()<CR>', options)
map('n', '<leader>wc', ':lua require("telescope").extensions.git_worktree.create_git_worktree()<CR>', options)
