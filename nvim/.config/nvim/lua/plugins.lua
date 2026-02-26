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

    {
      "NickvanDyke/opencode.nvim",
      dependencies = {
        -- Recommended for `ask()` and `select()`.
        -- Required for `snacks` provider.
        ---@module 'snacks' <- Loads `snacks.nvim` types for configuration intellisense.
        { "folke/snacks.nvim", opts = { input = {}, picker = {}, terminal = {} } },
      },
      config = function()
        ---@type opencode.Opts
        vim.g.opencode_opts = {
          -- Your configuration, if any — see `lua/opencode/config.lua`, or "goto definition".
        }

        -- Required for `opts.events.reload`.
        vim.o.autoread = true

        -- Recommended/example keymaps.
        vim.keymap.set({ "n", "x" }, "<C-a>", function() require("opencode").ask("@this: ", { submit = true }) end, { desc = "Ask opencode" })
        vim.keymap.set({ "n", "x" }, "<C-x>", function() require("opencode").select() end,                          { desc = "Execute opencode action…" })
        vim.keymap.set({ "n", "x" },    "ga", function() require("opencode").prompt("@this") end,                   { desc = "Add to opencode" })
        vim.keymap.set({ "n", "t" }, "<C-.>", function() require("opencode").toggle() end,                          { desc = "Toggle opencode" })
        vim.keymap.set("n",        "<S-C-u>", function() require("opencode").command("session.half.page.up") end,   { desc = "opencode half page up" })
        vim.keymap.set("n",        "<S-C-d>", function() require("opencode").command("session.half.page.down") end, { desc = "opencode half page down" })
        -- You may want these if you stick with the opinionated "<C-a>" and "<C-x>" above — otherwise consider "<leader>o".
        vim.keymap.set('n', '+', '<C-a>', { desc = 'Increment', noremap = true })
        vim.keymap.set('n', '-', '<C-x>', { desc = 'Decrement', noremap = true })
      end,
    },

    {
		'ThePrimeagen/99',
        config = function()
            require('config.99')
        end,
    },

    {

        'Exafunction/windsurf.vim',
        event = 'BufEnter'
    },

    -- {
    --     "ravitemer/mcphub.nvim",
    --     dependencies = {
    --         "nvim-lua/plenary.nvim",
    --     },
    --     build = "bundled_build.lua",  -- Bundles `mcp-hub` binary along with the neovim plugin
    --     config = function()
    --         require("mcphub").setup({
    --             use_bundled_binary = true,  -- Use local `mcp-hub` binary
    --         })
    --     end,
    -- },
    -- {
    --     "LeiTi34/magenta.nvim",
    --     branch = "openrouter",
    --     lazy = false, -- you could also bind to <leader>mt
    --     build = "npm install --frozen-lockfile",
    --     config = function()
    --         require('magenta').setup({
    --             profiles = {
    --                 {
    --                     name = "openai",
    --                     provider = "openrouter",
    --                     model = "openai/gpt-5",
    --                     fastModel = "openai/gpt-5-nano",
    --                     baseUrl = "https://openrouter.ai/api/v1",
    --                     apiKeyEnvVar = "OPENROUTER_API_KEY",
    --                 },
    --                 {
    --                     name = "anthropic",
    --                     provider = "openrouter",
    --                     model = "anthropic/claude-opus-4.1",
    --                     fastModel = "anthropic/claude-sonnet-4",
    --                     baseUrl = "https://openrouter.ai/api/v1",
    --                     apiKeyEnvVar = "OPENROUTER_API_KEY",
    --                 },
    --                 {
    --                     name = "google",
    --                     provider = "openrouter",
    --                     model = "google/gemini-2.5-pro",
    --                     fastModel = "google/gemini-2.5-flash",
    --                     baseUrl = "https://openrouter.ai/api/v1",
    --                     apiKeyEnvVar = "OPENROUTER_API_KEY",
    --                 },
    --             },
    --             mcpServers = {
    --                 mcphub = {
    --                     url = "http://localhost:37373/mcp"
    --                 }
    --             }
    --         })
    --     end,
    --     opts = {},
    -- },
    {
        'stevearc/oil.nvim',
        ---@module 'oil'
        ---@type oil.SetupOpts
        opts = {},
        -- Optional dependencies
        dependencies = { { "echasnovski/mini.icons", opts = {} } },
        -- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if you prefer nvim-web-devicons
        -- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
        lazy = false,
        config = function()
            require("oil").setup()
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
        tag = 'legacy',
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

    -- -- Jupyter
    -- {
    --     "benlubas/molten-nvim",
    --     version = "^1.0.0", -- use version <2.0.0 to avoid breaking changes
    --     build = ":UpdateRemotePlugins",
    --     dependencies = {
    --         "3rd/image.nvim",
    --     },
    --     init = function() require('config.molten') end,
    -- },
    -- {
    --     "quarto-dev/quarto-nvim",
    --     dependencies = {
    --         "jmbuhr/otter.nvim",
    --         "nvim-treesitter/nvim-treesitter",
    --     },
    --     config = function() require('config.quarto') end,
    --     ft = {"quarto", "markdown"},
    -- },
    -- {
    --     "GCBallesteros/jupytext.nvim",
    --     config = function() require('config.jupytext') end,
    --     -- Depending on your nvim distro or config you may need to make the loading not lazy
    --     -- lazy=false,
    -- },

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

    -- {
    --     'jcdickinson/http.nvim',
    --     build = 'cargo build --workspace --release'
    -- },
    {
        "Exafunction/windsurf.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "hrsh7th/nvim-cmp",
        },
        config = function()
            require("codeium").setup({
            })
        end
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
            { 'windwp/nvim-autopairs' },
        },
        config = function() require('config.cmp') end,
    },
    'saadparwaiz1/cmp_luasnip',

    -- LSP
    'barreiroleo/ltex-extra.nvim',
    {
        lazy = false,
        'neovim/nvim-lspconfig',
        dependencies = {
            'williamboman/mason.nvim',

            -- lspconfig
            'williamboman/mason-lspconfig.nvim',
            'barreiroleo/ltex-extra.nvim',
            -- 'brymer-meneses/grammar-guard.nvim',
            -- 'SmiteshP/nvim-navic',
            -- sqls
            -- 'nanotee/sqls.nvim',

            -- -- dap
            -- 'mfussenegger/nvim-dap',
            -- 'jayp0521/mason-nvim-dap.nvim',
            -- { 'rcarriga/nvim-dap-ui', dependencies = { 'nvim-neotest/nvim-nio' }},

            -- null-ls
            -- 'jose-elias-alvarez/null-ls.nvim',
            -- 'jayp0521/mason-null-ls.nvim',
            'mfussenegger/nvim-lint',
            {
                'stevearc/conform.nvim',
                opts = {
                    javascript = { "prettierd", "prettier", stop_after_first = true },
                    javascriptreact = { "prettierd", "prettier", stop_after_first = true },
                    typescript = { "prettierd", "prettier", stop_after_first = true },
                    typescriptreact = { "prettierd", "prettier", stop_after_first = true },
                },
                keys = {
                    {
                        "<leader>cf",
                        function()
                            require("conform").format({ lsp_format = "fallback" })
                        end,
                        mode = { "n" },
                        desc = "Format Injected Langs",
                    },
                    {
                        "<leader>cf",
                        function()
                            require("conform").format({
                                async = true,
                                lsp_fallback = true,
                                range = { start = vim.fn.getpos("'<"), ["end"] = vim.fn.getpos("'>") },
                            })
                        end,
                        mode = { "v" },
                        desc = "Format Injected Langs",
                    },
                }
            },
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

    -- -- Dadbod
    -- {
    --     'kristijanhusak/vim-dadbod-ui',
    --     dependencies = {'tpope/vim-dadbod'},
    --     keys = {
    --
    --         { '<leader>du', '<Cmd>DBUIToggle<CR>', desc='Dadbod' },
    --         { '<leader>df', '<Cmd>DBUIFindBuffer<CR>', desc='Dadbod' },
    --         { '<leader>dr', '<Cmd>DBUIRenameBuffer<CR>', desc='Dadbod' },
    --         { '<leader>dl', '<Cmd>DBUILastQueryInfo<CR>', desc='Dadbod' },
    --     },
    --     cmd = {
    --         'DBUI',
    --         'DBUIToggle',
    --         'DBUIFindBuffer',
    --         'DBUIRenameBuffer',
    --         'DBUILastQueryInfo',
    --         'DBUIAddConnection',
    --     },
    -- },
    --

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

    -- {
    --     'stevearc/overseer.nvim',
    --     config = function() require('config.overseer') end,
    --     keys = {
    --         { '<leader>tr', function() require('overseer').run_template() end, opts, desc='Overseer run template' },
    --         { '<leader>tT', function() require('overseer').toggle({ direction = 'right' }) end, opts, desc='Overseer toggle' },
    --         { '<leader>ta', function() require('overseer').run_action() end, opts, desc='Overseer' },
    --         { '<leader>tv', '<Cmd>OverseerQuickAction open vsplit<CR>', desc='Overseer open vsplit' },
    --         { '<leader>th', '<Cmd>OverseerQuickAction open hsplit<CR>', desc='Overseer open hsplit' },
    --         { '<leader>tf', '<Cmd>OverseerQuickAction open float<CR>', desc='Overseer open float' },
    --         { '<leader>to', '<Cmd>OverseerQuickAction open<CR>', desc='Overseer open' },
    --     },
    --     cmd = {
    --         'OverseerOpen',
    --         'OverseerClose',
    --         'OverseerToggle',
    --         'OverseerSaveBundle',
    --         'OverseerLoadBundle',
    --         'OverseerDeleteBundle',
    --         'OverseerRunCmd',
    --         'OverseerRun',
    --         'OverseerInfo',
    --         'OverseerBuild',
    --         'OverseerQuickAction',
    --         'OverseerTaskAction',
    --         'OverseerClearCache',
    --     },
    -- },

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
            {
                "<leader>xx",
                "<cmd>Trouble diagnostics toggle<cr>",
                desc = "Diagnostics (Trouble)",
            },
            {
                "<leader>xX",
                "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
                desc = "Buffer Diagnostics (Trouble)",
            },
            {
                "<leader>cs",
                "<cmd>Trouble symbols toggle focus=false<cr>",
                desc = "Symbols (Trouble)",
            },
            {
                "<leader>cl",
                "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
                desc = "LSP Definitions / references / ... (Trouble)",
            },
            {
                "<leader>xL",
                "<cmd>Trouble loclist toggle<cr>",
                desc = "Location List (Trouble)",
            },
            {
                "<leader>xQ",
                "<cmd>Trouble qflist toggle<cr>",
                desc = "Quickfix List (Trouble)",
            },
        },
        cmd = {
            'Trouble',
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

        -- {
        --     'dense-analysis/neural',
        --     dependencies = {
        --         'MunifTanjim/nui.nvim',
        --         'ElPiloto/significant.nvim',
        --     },
        --     config = function() require('config.neural') end,
        -- },

        {
            'mrcjkb/haskell-tools.nvim',
            version = '^3', -- Recommended
            ft = { 'haskell', 'lhaskell', 'cabal', 'cabalproject' },
        },

        -- {
        --     "yetone/avante.nvim",
        --     event = "VeryLazy",
        --     lazy = false,
        --     version = false, -- set this if you want to always pull the latest change
        --     opts = {
        --         mapping = { diff = { cursor = "cC" } },
        --     },
        --     -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
        --     build = "make",
        --     -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
        --     dependencies = {
        --         "nvim-treesitter/nvim-treesitter",
        --         "stevearc/dressing.nvim",
        --         "nvim-lua/plenary.nvim",
        --         "MunifTanjim/nui.nvim",
        --         --- The below dependencies are optional,
        --         "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
        --         "zbirenbaum/copilot.lua", -- for providers='copilot'
        --         {
        --             -- support for image pasting
        --             "HakonHarnes/img-clip.nvim",
        --             event = "VeryLazy",
        --             opts = {
        --                 -- recommended settings
        --                 default = {
        --                     embed_image_as_base64 = false,
        --                     prompt_for_file_name = false,
        --                     drag_and_drop = {
        --                         insert_mode = true,
        --                     },
        --                     -- required for Windows users
        --                     use_absolute_path = true,
        --                 },
        --             },
        --         },
        --         {
        --             -- Make sure to set this up properly if you have lazy=true
        --             'MeanderingProgrammer/render-markdown.nvim',
        --             opts = {
        --                 file_types = { "markdown", "Avante" },
        --             },
        --             ft = { "markdown", "Avante" },
        --         },
        --     },
        -- }
    })
