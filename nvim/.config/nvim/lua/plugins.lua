local map = vim.keymap.set

local options = { remap = false, silent = true, nowait = true }
local opts = options

-- Set up <Space> to be the global leader
map('n', '<Space>', '', opts)
vim.g.mapleader = ' '


local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

return require('lazy').setup({
    -- Get path to my pluginSettings config files

    -- 'lewis6991/impatient.nvim',

    --[[ -- Feline
    {
        'feline-nvim/feline.nvim',
        config = function() require('config.feline') end
    }, ]]

        -- Lualine
    {
        'nvim-lualine/lualine.nvim',
         dependencies = {
             { 'kyazdani42/nvim-web-devicons', opt = true },
             'arkav/lualine-lsp-progress',
            "SmiteshP/nvim-navic",
         },
         config = function() require('config.lualine') end
     },


    {
        'lewis6991/gitsigns.nvim',
        dependencies = 'nvim-lua/plenary.nvim',
        config = function() require('config.gitsigns') end
    },

    -- Bufferline
    -- {
    --     'akinsho/bufferline.nvim',
    --     dependencies = 'kyazdani42/nvim-web-devicons',
    --     config = function()
    --         --require('config.bufferline')
    --         vim.opt.termguicolors = true
    --         local bufferline = require("bufferline")
    --         bufferline.setup{
    --             options = {
    --                 diagnostics = 'nvim_lsp',
    --                 offsets = {{ filetype = 'CHADTree', text = 'CHADTree'}}
    --             }
    --         }
    --     end
    -- },

    -- {
    --     'noib3/nvim-cokeline',
    --     dependencies = 'kyazdani42/nvim-web-devicons',
    --     config = function() require('config.cokeline') end
    -- },

    -- Theme
    -- {
    --     'daschw/leaf.nvim',
    --     tag = 'v0.1.0',
    --     config = function() require('config.leaf-theme') end
    -- },

    {
        'navarasu/onedark.nvim',
        config = function()
            local onedark = require('onedark')
            onedark.setup({
                style = 'warmer'
            })
            onedark.load()
        end
    },

    -- {
    --     'shaunsingh/oxocarbon.nvim',
    --     build = './install.sh'
    --     config = function()
    --         vim.cmd.colorscheme "oxocarbon"
    --     end
    -- },

    --[[ {
        'projekt0n/github-nvim-theme',
        config = function() require('config.github-theme') end
    }, ]]
    -- 'sainnhe/sonokai',

    {
        'stevearc/dressing.nvim',
        config = function() require('config.dressing') end
    },

    -- CHADTree
    --[[ {
        'ms-jpq/chadtree',
        branch = 'chad',
        build = ':CHADdeps',
    }, ]]

    {
        'nvim-neo-tree/neo-tree.nvim',
         branch = 'v2.x',
         dependencies = {
            'nvim-lua/plenary.nvim',
            'kyazdani42/nvim-web-devicons', -- not strictly required, but recommended
            'MunifTanjim/nui.nvim',
            'mrbjarksen/neo-tree-diagnostics.nvim',
        },
        config = function () require('config.neo-tree') end
    },

    -- Telescope
    {
        'nvim-telescope/telescope.nvim',
        dependencies = {
            { 'nvim-lua/plenary.nvim' },
            { 'ThePrimeagen/git-worktree.nvim' }
        },
        config = function() require('config.telescope') end
    },

    'ThePrimeagen/git-worktree.nvim',
    'ThePrimeagen/vim-be-good',

    -- FZF
    -- 'junegunn/fzf.vim',

    -- Treesitter
    {
        'nvim-treesitter/nvim-treesitter',
        build = ':TSUpdate',
        dependencies = {
            -- Neorg
            'nvim-neorg/neorg',
            dependencies = {
                {'nvim-lua/plenary.nvim'},
                {'vhyrro/neorg-telescope'}
            },
            config = function() require('config.neorg') end,
        },
        config = function() require('config.treesitter') end
    },

    'nvim-treesitter/playground',

    {
        'nvim-treesitter/nvim-treesitter-textobjects',
        config = function() require('config.treesitter-textobjects') end
    },

    -- -- Fugitive
    -- {
    --     'tpope/vim-fugitive',
    --      after = 'cmp-nvim-lsp'
    --  },

    {
         'sindrets/diffview.nvim',
         dependencies = 'nvim-lua/plenary.nvim'
    },


    -- Neogit
    {
        'TimUntersberger/neogit',
        dependencies = 'nvim-lua/plenary.nvim',
        config = function()
            require('neogit').setup({
                integrations = {
                    diffview = true,
                }
            })
        end
    },

    -- - LSP TS Utils
    -- {
    --     'jose-elias-alvarez/nvim-lsp-ts-utils',
    --     dependencies = {
    --         {'neovim/nvim-lspconfig'},
    --         {'nvim-lua/plenary.nvim'},
    --         {'jose-elias-alvarez/null-ls.nvim'}
    --     },
    --     config = function()
    --         dofile(pluginSettings..'lspconfig.lua')
    --     end
    -- },

    -- {
    --     'L3MON4D3/LuaSnip',
    --     dependencies = 'rafamadriz/friendly-snippets',
    --     config = function () require('config.luasnip') end
    -- },

    -- 'neovim/nvim-lsp',
    --'aca/emmet-ls',

    {
        'windwp/nvim-autopairs',
        config = function() require('config.autopairs') end
    },

    {
        'hrsh7th/nvim-cmp',
        dependencies = {
            { 'hrsh7th/cmp-nvim-lsp', dependencies = 'neovim/nvim-lspconfig' },
            { 'onsails/lspkind-nvim' },
            { 'hrsh7th/cmp-buffer' },
            --{ 'hrsh7th/cmp-vsnip', dependencies = 'hrsh7th/vim-vsnip' },
            { 'hrsh7th/cmp-path' },
            { 'hrsh7th/cmp-calc' },
            { 'hrsh7th/cmp-cmdline' },
            { 'hrsh7th/cmp-emoji' },
            { 'tzachar/cmp-tabnine', build = './install.sh' },
            {
                'L3MON4D3/LuaSnip',
                dependencies = 'rafamadriz/friendly-snippets',
                config = function () require('config.luasnip') end,
            },
            { 'windwp/nvim-autopairs' },
        },
        config = function() require('config.cmp') end
    },
    'saadparwaiz1/cmp_luasnip',

    -- LSP
    'barreiroleo/ltex-extra.nvim',
    {
        'neovim/nvim-lspconfig',
        dependencies = {
            'williamboman/mason.nvim',

            -- lspconfig
            'williamboman/mason-lspconfig.nvim',
            'barreiroleo/ltex-extra.nvim',
            -- 'brymer-meneses/grammar-guard.nvim',
            'aspeddro/lsp_menu.nvim',
            'SmiteshP/nvim-navic',

            -- dap
            'mfussenegger/nvim-dap',
            'jayp0521/mason-nvim-dap.nvim',
            'rcarriga/nvim-dap-ui',

            -- null-ls
            'jose-elias-alvarez/null-ls.nvim',
            'jayp0521/mason-null-ls.nvim',
        },
        config = function() require('config.mason') end
    },
    -- -- Debugger
    -- {
    --     dependencies = { 'mfussenegger/nvim-dap' },
    --     config = function() require('config.dap') end
    -- },


    -- {
    --     'VonHeikemen/lsp-zero.nvim',
    --     dependencies = {
    --         -- LSP Support
    --         {'neovim/nvim-lspconfig'},
    --         {'williamboman/mason.nvim'},
    --         {'williamboman/mason-lspconfig.nvim'},
    --
    --         -- Autocompletion
    --         {'hrsh7th/nvim-cmp'},
    --         {'hrsh7th/cmp-buffer'},
    --         {'hrsh7th/cmp-path'},
    --         {'saadparwaiz1/cmp_luasnip'},
    --         {'hrsh7th/cmp-nvim-lsp'},
    --         {'hrsh7th/cmp-nvim-lua'},
    --
    --         -- Snippets
    --         {'L3MON4D3/LuaSnip'},
    --         {'rafamadriz/friendly-snippets'},
    --     },
    --     config = function()
    --         local lsp = require('lsp-zero')
    --         lsp.preset('recommended')
    --         lsp.setup()
    --     end
    -- },


    -- {
    --     'williamboman/mason.nvim',
    --     dependencies = 'williamboman/mason-lspconfig.nvim',
    --     config = function() require('mason').setup() end
    -- },
    --
    -- 'github/copilot.vim',

    -- Code Action Menu
    {
        'weilbith/nvim-code-action-menu',
        cmd = 'CodeActionMenu',
    },

    -- Toggleterm
    {
        'akinsho/toggleterm.nvim',
        config = function() require('config.toggleterm') end
    },

    -- Dadbod
    {
        'kristijanhusak/vim-dadbod-ui',
        dependencies = {'tpope/vim-dadbod'}
    },


    -- Harpoon
    {
        'ThePrimeagen/harpoon',
        dependencies = 'nvim-lua/plenary.nvim',
        config = function() require('config.harpoon') end
    },

    -- TS Autotag
    {
        'windwp/nvim-ts-autotag',
        dependencies = 'nvim-treesitter/nvim-treesitter',
        config = function() require('config.ts-autotag') end
    },

    -- Comment
    {
        'numToStr/Comment.nvim',
        config = function() require('config.comment') end
    },

    -- -- Startup
    -- {
    --     'startup-nvim/startup.nvim',
    --     dependencies = {
    --         'nvim-telescope/telescope.nvim',
    --         'nvim-lua/plenary.nvim'
    --     },
    --     config = function() require('config.startup') end
    -- },

    {
        'goolord/alpha-nvim',
        dependencies = 'kyazdani42/nvim-web-devicons',
        config = function () require('config.alpha') end
    },

    {
        'Shatur/neovim-session-manager',
        dependencies = 'nvim-lua/plenary.nvim',
        config = function() require('config.session-manager') end
    },

    -- {
    --     'jedrzejboczar/possession.nvim',
    --     dependencies = 'nvim-lua/plenary.nvim',
    --     config = function () require('config.possession') end
    -- },

    -- {
    --     'pianocomposer321/yabs.nvim',
    --     dependencies = 'nvim-lua/plenary.nvim',
    --     config = function() require('config.yabs') end
    -- },

    {
        'stevearc/overseer.nvim',
        config = function() require('config.overseer') end
    },

    {
        'ziontee113/syntax-tree-surfer',
        config = function() require('syntax-tree-surfer').setup() end
    },

    -- Lua
    {
        'folke/todo-comments.nvim',
        dependencies = 'nvim-lua/plenary.nvim',
        config = function() require('config.todo-comments') end
    },

    {
        "folke/trouble.nvim",
        dependencies = "kyazdani42/nvim-web-devicons",
        config = function() require('config.trouble') end
    },

    {
        'NvChad/nvim-colorizer.lua',
        config = function() require('config.colorizer') end
    },

    {
        'dense-analysis/neural',
        dependencies = {
            'MunifTanjim/nui.nvim',
            'ElPiloto/significant.nvim',
        },
        config = function() require('config.neural') end,
    }
    -- -- nvim-docker
    -- {
    --     'dgrbrady/nvim-docker',
    --     dependencies = {'nvim-lua/plenary.nvim', 'MunifTanjim/nui.nvim'},
    --     rocks = 'reactivex' -- ReactiveX Lua implementation
    -- },
})
