local opt = vim.opt

-- vim.cmd[[colorscheme sonokai]]
opt.termguicolors = true

opt.modelines = 1

opt.showmode = false
opt.ruler = false
opt.showcmd = false

opt.splitbelow = true

opt.laststatus = 3

opt.number = true
opt.relativenumber = true

opt.mouse = 'a'
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true

opt.hlsearch = false

opt.guifont = {'Fira Code', ':h11'}

opt.undodir = os.getenv("XDG_CACHE_HOME") .. '/nvim/undodir'
opt.undofile = true

--[[
vim.opt.completeopt = "menu,menuone,noselect" ]]
