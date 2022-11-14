local map = vim.keymap.set

local options = { remap = false, silent = true, nowait = true }
local opts = options

-- Set up <Space> to be the global leader
map('n', '<Space>', '', opts)
vim.g.mapleader = ' '


-- Window navigation
map('n', '<leader>h', '<Cmd>wincmd h<CR>', opts)
map('n', '<leader>j', '<Cmd>wincmd j<CR>', opts)
map('n', '<leader>k', '<Cmd>wincmd k<CR>', opts)
map('n', '<leader>l', '<Cmd>wincmd l<CR>', opts)

-- Telescope
local telescope_builtin = require('telescope.builtin')
map('n', '<leader>fb', telescope_builtin.buffers, opts)
map('n', '<leader>ff', telescope_builtin.find_files, opts)
map('n', '<leader>fg', telescope_builtin.live_grep, opts)
map('n', '<leader>fh', telescope_builtin.help_tags, opts)
map('n', '<leader>fk', telescope_builtin.keymaps, opts)
map('n', '<leader>fr', telescope_builtin.registers, opts)

map('n', '<leader>fs', '<Cmd>SessionManager load_session<CR>', opts)
-- map('n', '<leader>ft', '<Cmd>Telescope yabs tasks<CR>', opts)

-- Neotree
map('n','<leader>nn', '<Cmd>Neotree reveal toggle source=filesystem<CR>', opts)
map('n','<leader>nb', '<Cmd>Neotree reveal toggle source=buffers<CR>', opts)
map('n','<leader>ng', '<Cmd>Neotree reveal toggle source=git_status<CR>', opts)
map('n','<leader>nd', '<Cmd>Neotree reveal bottom toggle source=diagnostics<CR>', opts)

-- Neogit
map('n', '<leader>gs', '<Cmd>lua require("neogit").open()<CR>', opts)

-- Cokeline
map('n', '<leader>bb', '<Plug>(cokeline-pick-focus)', opts)
map('n', '<leader>bc', '<Plug>(cokeline-pick-close)', opts)
map('n', '<leader>bn', '<Plug>(cokeline-focus-next)', opts)
map('n', '<leader>bp', '<Plug>(cokeline-focus-prev)', opts)

-- Dadbod UI
map('n', '<leader>du', '<Cmd>DBUIToggle<CR>', opts)
map('n', '<leader>df', '<Cmd>DBUIFindBuffer<CR>', opts)
map('n', '<leader>dr', '<Cmd>DBUIRenameBuffer<CR>', opts)
map('n', '<leader>dl', '<Cmd>DBUILastQueryInfo<CR>', opts)

-- Harpoon
local harpoon_mark = require("harpoon.mark")
map('n', '<leader>Ha', harpoon_mark.add_file, opts)
local harpoon_ui = require("harpoon.ui")
map('n', '<leader>Hm', harpoon_ui.toggle_quick_menu, opts)
-- Harpoon navigation
map('n', '<C-h>', function() harpoon_ui.nav_file(1) end, opts)
map('n', '<C-j>', function() harpoon_ui.nav_file(2) end, opts)
map('n', '<C-k>', function() harpoon_ui.nav_file(3) end, opts)
map('n', '<C-l>', function() harpoon_ui.nav_file(4) end, opts)
local harpoon_cmd_ui = require("harpoon.cmd-ui")
map('n', '<leader>tm', harpoon_cmd_ui.toggle_quick_menu, opts)
-- local harpoon_term = require("harpoon.term")
-- map('n', '<leader>th', function() harpoon_term.gotoTerminal(1) end, opts)
-- map('n', '<leader>tj', function() harpoon_term.gotoTerminal(2) end, opts)
-- map('n', '<leader>tk', function() harpoon_term.gotoTerminal(3) end, opts)
-- map('n', '<leader>tl', function() harpoon_term.gotoTerminal(4) end, opts)
-- map('n', '<leader>ch', function() harpoon_term.sendCommand(2, 1) end, opts)
-- map('n', '<leader>cj', function() harpoon_term.sendCommand(1, 2) end, opts)
-- map('n', '<leader>ck', function() harpoon_term.sendCommand(1, 3) end, opts)
-- map('n', '<leader>cl', function() harpoon_term.sendCommand(1, 4) end, opts)

-- -- yabs
-- local yabs = require("yabs")
-- map('n', '<leader>tr', yabs.run_default_task, opts)

-- Overseer.nvim
local overseer = require("overseer")
map('n', '<leader>ft', overseer.run_template, opts)
map('n', '<leader>tO', function() overseer.toggle({ direction = 'right' }) end, opts)
map('n', '<leader>tT', function() overseer.toggle({ direction = 'right' }) end, opts)
map('n', '<leader>tr', overseer.run_template, opts)
map('n', '<leader>ta', overseer.run_action, opts)
map('n', '<leader>tv', '<Cmd>OverseerQuickAction open vsplit<CR>', opts)
map('n', '<leader>th', '<Cmd>OverseerQuickAction open hsplit<CR>', opts)
map('n', '<leader>tf', '<Cmd>OverseerQuickAction open float<CR>', opts)
map('n', '<leader>to', '<Cmd>OverseerQuickAction open<CR>', opts)

-- todo-comments
map('n', '<leader>tc', '<Cmd>TodoQuickFix<CR>', opts)
map('n', '<leader>tC', '<Cmd>TodoTelescope<CR>', opts)

--troubles
map('n', '<leader>td', '<Cmd>TroubleToggle<CR>', opts)

-- Git Worktree
local telescope = require("telescope")
map('n', '<leader>ww', telescope.extensions.git_worktree.git_worktrees, opts)
map('n', '<leader>wc', telescope.extensions.git_worktree.create_git_worktree, opts)

-- Session
map('n', '<leader>sf', '<Cmd>SessionManager load_session<CR>', opts)
map('n', '<leader>sl', '<Cmd>SessionManager load_last_session<CR>', opts)
map('n', '<leader>ss', '<Cmd>SessionManager save_current_session<CR>', opts)

-- Navigate Quick fix list
map('n', '[q', '<Cmd>cprev<CR>', opts)
map('n', ']q', '<Cmd>cnext<CR>', opts)

-- Syntax Tree Surfer
-- Normal Mode Swapping:
-- Swap The Master Node relative to the cursor with it's siblings, Dot Repeatable
vim.keymap.set("n", "vU", function()
	vim.opt.opfunc = "v:lua.STSSwapUpNormal_Dot"
	return "g@l"
end, { silent = true, expr = true })
vim.keymap.set("n", "vD", function()
	vim.opt.opfunc = "v:lua.STSSwapDownNormal_Dot"
	return "g@l"
end, { silent = true, expr = true })

-- Swap Current Node at the Cursor with it's siblings, Dot Repeatable
vim.keymap.set("n", "vd", function()
	vim.opt.opfunc = "v:lua.STSSwapCurrentNodeNextNormal_Dot"
	return "g@l"
end, { silent = true, expr = true })
vim.keymap.set("n", "vu", function()
	vim.opt.opfunc = "v:lua.STSSwapCurrentNodePrevNormal_Dot"
	return "g@l"
end, { silent = true, expr = true })

--> If the mappings above don't work, use these instead (no dot repeatable)
-- vim.keymap.set("n", "vd", '<cmd>STSSwapCurrentNodeNextNormal<cr>', opts)
-- vim.keymap.set("n", "vu", '<cmd>STSSwapCurrentNodePrevNormal<cr>', opts)
-- vim.keymap.set("n", "vD", '<cmd>STSSwapDownNormal<cr>', opts)
-- vim.keymap.set("n", "vU", '<cmd>STSSwapUpNormal<cr>', opts)

-- Visual Selection from Normal Mode
vim.keymap.set("n", "vx", '<cmd>STSSelectMasterNode<cr>', opts)
vim.keymap.set("n", "vn", '<cmd>STSSelectCurrentNode<cr>', opts)

-- Select Nodes in Visual Mode
vim.keymap.set("x", "J", '<cmd>STSSelectNextSiblingNode<cr>', opts)
vim.keymap.set("x", "K", '<cmd>STSSelectPrevSiblingNode<cr>', opts)
vim.keymap.set("x", "H", '<cmd>STSSelectParentNode<cr>', opts)
vim.keymap.set("x", "L", '<cmd>STSSelectChildNode<cr>', opts)

-- Swapping Nodes in Visual Mode
vim.keymap.set("x", "<A-j>", '<cmd>STSSwapNextVisual<cr>', opts)
vim.keymap.set("x", "<A-k>", '<cmd>STSSwapPrevVisual<cr>', opts)


-- Terminal remaps
map('t', '<esc>', '<C-\\><C-n>', opts)
map('t', '<C-v><esc>', '<esc>', opts)

