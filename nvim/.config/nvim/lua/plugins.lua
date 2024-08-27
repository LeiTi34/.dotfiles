local options = { remap = false, silent = true, nowait = true }
local opts = options

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
    {
        'rebelot/kanagawa.nvim',
        config = function()
            require('kanagawa').setup({
                overrides = function(colors)
                    local theme = colors.theme
                    return {
                        -- FoldColumn = { bg = theme.ui.bg },
                        -- LineNr = { fg = theme.ui.fg, bg = theme.ui.bg },
                        -- SignColumn = { bg = theme.ui.bg },
                        -- CursorLineNr = { bg = theme.ui.bg },
                        -- DiagnosticSignError = { bg = theme.ui.bg },
                        -- DiagnosticSignWarn = { bg = theme.ui.bg },
                        -- DiagnosticSignInfo = { bg = theme.ui.bg },
                        -- DiagnosticSignHint = { bg = theme.ui.bg },
                    }
                end,
            })
            vim.cmd("colorscheme kanagawa-dragon")
            -- require('kanagawa').setup()
            -- vim.colorscheme('kanagawa')
        end,
    },

    {
      'supermaven-inc/supermaven-nvim',
      config = function()
        require('supermaven-nvim').setup({})
      end,
    },

    -- {
    --     'NTBBloodbath/sweetie.nvim',
    --     config = function()
    --         require('sweetie.nvim').setup()
    --         vim.cmd.colorscheme('sweetie')
    --     end
    -- },

    -- {
    --     'navarasu/onedark.nvim',
    --     config = function()
    --         local onedark = require('onedark')
    --         onedark.setup({
    --             style = 'warmer'
    --         })
    --         onedark.load()
    --     end,
    -- },

    -- {
    --     '2nthony/vitesse.nvim',
    --     dependencies = {
    --         'tjdevries/colorbuddy.nvim'
    --     },
    --     config = function()
    --         require("vitesse").setup {
    --             comment_italics = true,
    --             float_background = false,
    --             reverse_visual = false,
    --         }
    --     end,
    -- },

    -- {
    --     'arturgoms/moonbow.nvim'
    -- },
    -- install = { colorscheme = { 'moonbow' } },

    -- Lualine
    {
        'nvim-lualine/lualine.nvim',
         dependencies = {
             { 'kyazdani42/nvim-web-devicons', opt = true },
             'arkav/lualine-lsp-progress',
            "SmiteshP/nvim-navic",
         },
         config = function() require('config.lualine') end,
     },
    -- Winbar
    {
        "utilyre/barbecue.nvim",
        name = "barbecue",
        version = "*",
        dependencies = {
            "SmiteshP/nvim-navic",
            "kyazdani42/nvim-web-devicons", -- optional dependency
        },
        config = function()
            require('barbecue').setup()
            require('barbecue.ui').toggle(true)
        end,
        -- opts = {
        --     -- configurations go here
        -- },
    },
    -- LSP Status
    {
        'j-hui/fidget.nvim',
        config = function() require"fidget".setup() end,
    },


    {
        'lewis6991/gitsigns.nvim',
        dependencies = 'nvim-lua/plenary.nvim',
        config = function() require('config.gitsigns') end,
    },

    {
        'stevearc/dressing.nvim',
        config = function() require('config.dressing') end,
    },

    {
        'nvim-neo-tree/neo-tree.nvim',
         branch = 'v3.x',
         dependencies = {
            'nvim-lua/plenary.nvim',
            'kyazdani42/nvim-web-devicons', -- not strictly required, but recommended
            'MunifTanjim/nui.nvim',
            'mrbjarksen/neo-tree-diagnostics.nvim',
        },
        config = function () require('config.neo-tree') end,
        keys = {
            { '<leader>nn', '<Cmd>Neotree reveal toggle source=filesystem<CR>', opts, desc='Neotree filesystem' },
            { '<leader>nb', '<Cmd>Neotree reveal toggle source=buffers<CR>', opts, desc='Neotree buffers' },
            { '<leader>ng', '<Cmd>Neotree reveal toggle source=git_status<CR>', opts, desc='Neotree git' },
            { '<leader>nd', '<Cmd>Neotree reveal bottom toggle source=diagnostics<CR>', opts, desc='Neotree diagnostics' },
        },
        cmd = 'Neotree',
    },
    {
        "antosha417/nvim-lsp-file-operations",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-neo-tree/neo-tree.nvim",
        },
        config = function()
            require("lsp-file-operations").setup()
        end,
    },
    {
        'stevearc/oil.nvim',
        opts = {},
        -- Optional dependencies
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("oil").setup()
        end,
    },

    -- Telescope
    {
        'nvim-telescope/telescope.nvim',
        dependencies = {
            { 'nvim-lua/plenary.nvim' },
            { 'ThePrimeagen/git-worktree.nvim' }
        },
        config = function() require('config.telescope') end,
        keys = {
            { '<leader>fb', function() require('telescope.builtin').buffers() end, opts, desc='Telescope find buffers' },
            { '<leader>ff', function() require('telescope.builtin').find_files() end, opts, desc='Telescope find files' },
            { '<leader>fg', function() require('telescope.builtin').live_grep() end, opts, desc='Telescope live grep' },
            { '<leader>fh', function() require('telescope.builtin').help_tags() end, opts, desc='Telescope find help' },
            { '<leader>fk', function() require('telescope.builtin').keymaps() end, opts, desc='Telescope find keys' },
            { '<leader>fr', function() require('telescope.builtin').registers() end, opts, desc='Telescope find registers' },
            { '<leader>ww', function() require('telescope').extensions.git_worktree.git_worktrees() end, opts, desc='Worktree open' },
            { '<leader>wc', function() require('telescope').extensions.git_worktree.create_git_worktree() end, opts, desc='Worktree create' },
        },
    },

    'ThePrimeagen/git-worktree.nvim',
    'ThePrimeagen/vim-be-good',

    -- Treesitter
    {
        'nvim-treesitter/nvim-treesitter',
        build = ':TSUpdate',
        -- dependencies = {
        --     -- Neorg
        --     'nvim-neorg/neorg', -- TODO better lazy loading
        --     dependencies = {
        --         {'nvim-lua/plenary.nvim'},
        --         {'vhyrro/neorg-telescope'}
        --     },
        --     config = function() require('config.neorg') end,
        -- },
        config = function() require('config.treesitter') end,
    },

    'nvim-treesitter/playground',

    {
        'nvim-treesitter/nvim-treesitter-textobjects',
        config = function() require('config.treesitter-textobjects') end,
    },

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
        end,
        keys = {
            { '<leader>gs', function () require("neogit").open() end, opts, desc='Open Neogit' },
        },
        cmd = 'Neogit',
    },

    {
        'windwp/nvim-autopairs',
        config = function() require('config.autopairs') end,
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
                build = 'make install_jsregexp',
                config = function () require('config.luasnip') end,
            },
            { 'windwp/nvim-autopairs' },
        },
        config = function() require('config.cmp') end,
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
            -- 'SmiteshP/nvim-navic',

            -- dap
            'nvim-neotest/nvim-nio',
            'mfussenegger/nvim-dap',
            'jayp0521/mason-nvim-dap.nvim',
            'rcarriga/nvim-dap-ui',

            -- null-ls
            'jose-elias-alvarez/null-ls.nvim',
            'jayp0521/mason-null-ls.nvim',
        },
        config = function() require('config.mason') end,
    },

    -- Code Action Menu
    {
        'weilbith/nvim-code-action-menu',
        cmd = 'CodeActionMenu',
    },

    -- Toggleterm
    {
        'akinsho/toggleterm.nvim',
        config = function() require('config.toggleterm') end,
    },

    -- Dadbod
    {
        'kristijanhusak/vim-dadbod-ui',
        dependencies = {'tpope/vim-dadbod'},
        keys = {

            { '<leader>du', '<Cmd>DBUIToggle<CR>', desc='Dadbod' },
            { '<leader>df', '<Cmd>DBUIFindBuffer<CR>', desc='Dadbod' },
            { '<leader>dr', '<Cmd>DBUIRenameBuffer<CR>', desc='Dadbod' },
            { '<leader>dl', '<Cmd>DBUILastQueryInfo<CR>', desc='Dadbod' },
        },
        cmd = {
            'DBUI',
            'DBUIToggle',
            'DBUIFindBuffer',
            'DBUIRenameBuffer',
            'DBUILastQueryInfo',
            'DBUIAddConnection',
        },
    },


    -- Harpoon
    {
        'ThePrimeagen/harpoon',
        dependencies = 'nvim-lua/plenary.nvim',
        config = function() require('config.harpoon') end,
        keys = {
            { "<leader>Ha", function() require('harpoon.mark').add_file() end, opts, desc='Harpoon add file' },
            { "<leader>Hm", function() require('harpoon.ui').toggle_quick_menu() end, opts, desc='Harpoon toggle UI' },
            { '<C-h>', function() require('harpoon.ui').nav_file(1) end, opts, desc='Harpoon move to 1' },
            { '<C-j>', function() require('harpoon.ui').nav_file(2) end, opts, desc='Harpoon move to 2' },
            { '<C-k>', function() require('harpoon.ui').nav_file(3) end, opts, desc='Harpoon move to 3' },
            { '<C-l>', function() require('harpoon.ui').nav_file(4) end, opts, desc='Harpoon move to 4' },
        },
    },

    -- TS Autotag
    {
        'windwp/nvim-ts-autotag',
        dependencies = 'nvim-treesitter/nvim-treesitter',
        config = function() require('config.ts-autotag') end,
    },

    -- Comment
    {
        'numToStr/Comment.nvim',
        config = function() require('config.comment') end,
    },

    {
        'goolord/alpha-nvim',
        dependencies = 'kyazdani42/nvim-web-devicons',
        config = function () require('config.alpha') end,
    },

    {
        'stevearc/overseer.nvim',
        config = function() require('config.overseer') end,
        keys = {
            { '<leader>tr', function() require('overseer').run_template() end, opts, desc='Overseer run template' },
            { '<leader>tT', function() require('overseer').toggle({ direction = 'right' }) end, opts, desc='Overseer toggle' },
            { '<leader>ta', function() require('overseer').run_action() end, opts, desc='Overseer' },
            { '<leader>tv', '<Cmd>OverseerQuickAction open vsplit<CR>', desc='Overseer open vsplit' },
            { '<leader>th', '<Cmd>OverseerQuickAction open hsplit<CR>', desc='Overseer open hsplit' },
            { '<leader>tf', '<Cmd>OverseerQuickAction open float<CR>', desc='Overseer open float' },
            { '<leader>to', '<Cmd>OverseerQuickAction open<CR>', desc='Overseer open' },
        },
        cmd = {
            'OverseerOpen',
            'OverseerClose',
            'OverseerToggle',
            'OverseerSaveBundle',
            'OverseerLoadBundle',
            'OverseerDeleteBundle',
            'OverseerRunCmd',
            'OverseerRun',
            'OverseerInfo',
            'OverseerBuild',
            'OverseerQuickAction',
            'OverseerTaskAction',
            'OverseerClearCache',
        },
    },

    -- Lua
    {
        'folke/todo-comments.nvim',
        dependencies = 'nvim-lua/plenary.nvim',
        config = function() require('config.todo-comments') end,
        lazy = false,
        keys = {
            { '<leader>tc', '<Cmd>TodoQuickFix<CR>', desc='TodoComments quickfix' },
            { '<leader>tC', '<Cmd>TodoTelescope<CR>', desc='TodoComments telescope' },
        },
    },

    {
        "folke/trouble.nvim",
        dependencies = "kyazdani42/nvim-web-devicons",
        config = function() require('config.trouble') end,
        keys = {
            { '<leader>td', '<Cmd>TroubleToggle<CR>', desc='Trouble toggle' },
        },
        cmd = {
            'Trouble',
            'TroubleToggle',
            'TroubleClose',
            'TroubleRefresh',
        },
    },

    {
        'NvChad/nvim-colorizer.lua',
        config = function() require('config.colorizer') end,
    },

    -- {
    --     'barrett-ruth/import-cost.nvim',
    --     build = 'sh install.sh npm',
    --     config = true
    -- },

    {
        'dense-analysis/neural',
        dependencies = {
            'MunifTanjim/nui.nvim',
            'ElPiloto/significant.nvim',
        },
        config = function() require('config.neural') end,
    }
})
