local map = vim.keymap.set

local options = { remap = false, silent = true, nowait = true }
local opts = options

-- Set up <Space> to be the global leader
map('n', '<Space>', '', opts)
vim.g.mapleader = ' '

vim.g.maplocalleader = ' p'

-- Window navigation
map('n', '<leader>h', '<Cmd>wincmd h<CR>', opts)
map('n', '<leader>j', '<Cmd>wincmd j<CR>', opts)
map('n', '<leader>k', '<Cmd>wincmd k<CR>', opts)
map('n', '<leader>l', '<Cmd>wincmd l<CR>', opts)

-- Navigate Quick fix list
map('n', '[q', '<Cmd>cprev<CR>', opts)
map('n', ']q', '<Cmd>cnext<CR>', opts)

-- Terminal remaps
map('t', '<esc>', '<C-\\><C-n>', opts)
map('t', '<C-v><esc>', '<esc>', opts)

-- Remap C-d, C-u to center the screen
map('n', '<C-d>', '<C-d>zz', opts)
map('n', '<C-u>', '<C-u>zz', opts)
