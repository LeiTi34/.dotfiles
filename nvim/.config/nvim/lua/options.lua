-- vim.cmd[[colorscheme sonokai]]
vim.opt.termguicolors = true

vim.o.modelines = 1

vim.o.showmode = false
vim.o.ruler = false
vim.o.showcmd = false

vim.o.splitbelow = true

vim.o.laststatus = 3

vim.o.number = true
vim.o.relativenumber = true

vim.o.mouse = 'a'

vim.o.tabstop = 4
vim.bo.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4
vim.bo.shiftwidth = 4
vim.o.expandtab = true
vim.bo.expandtab = true

vim.o.hlsearch = false

-- opt.guifont = {'CaskaydiaCove Nerd Font', ':h12'}
vim.opt.guifont = {'Fira Code', ':h11'}
-- opt.guifont = {'VictorMono Nerd Font', ':style=Medium',':h12'}

vim.o.undodir = os.getenv("XDG_CACHE_HOME") .. '/nvim/undodir'
vim.o.undofile = true

-- Wrap lines
vim.o.wrap = true

--[[
vim.opt.completeopt = "menu,menuone,noselect" ]]
