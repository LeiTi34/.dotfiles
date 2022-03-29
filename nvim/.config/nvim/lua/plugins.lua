-- This file can be loaded by calling `lua require('plugins')` from your init.vim

vim.cmd ('packadd packer.nvim')

local packer = require('packer')
if not packer then
    print('Packer was not found')
    return
end


return packer.startup({function()
    -- Get path to my pluginSettings config files

    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    use 'lewis6991/impatient.nvim'

    -- Feline
    use {
        'feline-nvim/feline.nvim',
        config = function() require('config.feline') end
    }

    use {
        'lewis6991/gitsigns.nvim',
        requires = 'nvim-lua/plenary.nvim',
        config = function() require('config.gitsigns') end
    }

    -- Bufferline
    use {
        'akinsho/bufferline.nvim',
        requires = 'kyazdani42/nvim-web-devicons',
        config = function() 
            --require('config.bufferline') 
            vim.opt.termguicolors = true
            local bufferline = require("bufferline")
            bufferline.setup{
                options = {
                    diagnostics = 'nvim_lsp',
                    offsets = {{ filetype = 'CHADTree', text = 'CHADTree'}} 
                }
            }
        end
    }
    -- Theme
    use {
        'projekt0n/github-nvim-theme',
        config = function() require('config.github-theme') end
    }
    -- use 'sainnhe/sonokai'

    use {
        'stevearc/dressing.nvim',
        config = function() require('config.dressing') end
    }

    -- CHADTree
    use {
        'ms-jpq/chadtree',
        branch = 'chad',
        run = ':CHADdeps',
    }

    -- Telescope
    use {
        'nvim-telescope/telescope.nvim',
        requires = {
            { 'nvim-lua/plenary.nvim' },
            { 'ThePrimeagen/git-worktree.nvim' }
        },
        config = function() require('config.telescope') end
    }

    use 'ThePrimeagen/git-worktree.nvim'

    -- FZF
    -- use 'junegunn/fzf.vim'

    -- Treesitter
    use {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate',
        config = function() require('config.treesitter') end
    }
    use 'nvim-treesitter/playground'

    use {
        'nvim-treesitter/nvim-treesitter-textobjects',
        config = function() require('config.treesitter-textobjects') end
    }

    -- Fugitive
    use {
        'tpope/vim-fugitive',
         after = 'cmp-nvim-lsp'
     }

    use {
         'sindrets/diffview.nvim',
         requires = 'nvim-lua/plenary.nvim'
    }


    -- Neogit
    use {
        'TimUntersberger/neogit',
        requires = 'nvim-lua/plenary.nvim'
    }

    -- - LSP TS Utils
    -- use {
    --     'jose-elias-alvarez/nvim-lsp-ts-utils',
    --     requires = {
    --         {'neovim/nvim-lspconfig'},
    --         {'nvim-lua/plenary.nvim'},
    --         {'jose-elias-alvarez/null-ls.nvim'}
    --     },
    --     config = function()
    --         dofile(pluginSettings..'lspconfig.lua')
    --     end
    -- }

    -- use 'neovim/nvim-lsp'
    --use 'aca/emmet-ls'
    use {
        'hrsh7th/nvim-cmp',
        requires = {
            { 'neovim/nvim-lspconfig' },
            { 'onsails/lspkind-nvim' },
            { 'hrsh7th/cmp-buffer', after = 'nvim-cmp' },
            { 'hrsh7th/cmp-vsnip', after = 'nvim-cmp' , requires = 'hrsh7th/vim-vsnip' },
            { 'hrsh7th/cmp-path', after = 'nvim-cmp' },
            { 'hrsh7th/cmp-calc', after = 'nvim-cmp' },
            { 'hrsh7th/cmp-cmdline', after = 'nvim-cmp' },
            { 'hrsh7th/cmp-emoji', after = 'nvim-cmp' },
            { 'hrsh7th/cmp-nvim-lsp', after = 'nvim-cmp' },
            { 'tzachar/cmp-tabnine', run = './install.sh' },
        },
        config = function() require('config.cmp') end
    }

    -- LSP
    use {
        'neovim/nvim-lspconfig',
        after = 'cmp-nvim-lsp',
        requires = {
            'brymer-meneses/grammar-guard.nvim',
            requires = 'neovim/nvim-lspconfig.lua'
        },
        config = function() require('config.lspconfig') end
    }

    use 'github/copilot.vim'

    -- Code Action Menu
    use {
        'weilbith/nvim-code-action-menu',
        cmd = 'CodeActionMenu',
    }

    -- Toggleterm
    use {
        'akinsho/toggleterm.nvim',
        config = function() require('config.toggleterm') end
    }

    -- Dadbod
    use {
        'kristijanhusak/vim-dadbod-ui',
        requires = {'tpope/vim-dadbod'}
    }

    -- Neorg
    use { 
        'nvim-neorg/neorg',
        after = 'nvim-treesitter',
        requires = {
            {'nvim-lua/plenary.nvim'},
            {'vhyrro/neorg-telescope'}
        },
        config = function() require('config.neorg') end,
    }

    -- Harpoon
    use {
        'ThePrimeagen/harpoon',
        requires = 'nvim-lua/plenary.nvim',
        config = function() require('config.harpoon') end
    }

    -- TS Autotag
    use {
        'windwp/nvim-ts-autotag',
        requires = 'nvim-treesitter/nvim-treesitter',
        config = function() require('config.ts-autotag') end
    }

    -- Comment
    use {
        'numToStr/Comment.nvim',
        config = function() require('config.comment') end
    }

    -- Startup
    use {
        'startup-nvim/startup.nvim',
        requires = {
            'nvim-telescope/telescope.nvim',
            'nvim-lua/plenary.nvim'
        },
        config = function() require('config.startup') end
    }

    -- Debugger
    use {
        'rcarriga/nvim-dap-ui',
        requires = { 'mfussenegger/nvim-dap' },
        config = function() require('config.dap') end
    }

end,
config = {
    display = {
        open_fn = function()
            return require('packer.util').float({ border = 'single' })
        end
    },
    compile_on_sync = true
}})
