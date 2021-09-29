-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]
-- -- Only if your version of Neovim doesn't have https://github.com/neovim/neovim/pull/12632 merged
-- vim._update_package_paths()

return require('packer').startup(function()
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'
  
  -- Feline
  use 'famiu/feline.nvim'

  use {
    'lewis6991/gitsigns.nvim',
    requires = {
      'nvim-lua/plenary.nvim'
    },
    config = function()
      require('gitsigns').setup()
    end
  }

  -- Bufferline
  use {
      'akinsho/bufferline.nvim',
      requires = 'kyazdani42/nvim-web-devicons'
  }
  -- Theme
  use 'projekt0n/github-nvim-theme'
  -- use 'sainnhe/sonokai'

  -- COQ
  use { 
    'ms-jpq/coq_nvim', 
    branch = 'coq',
    run = ':COQdeps'
  }
  use { 
    'ms-jpq/coq.artifacts', 
    branch = 'artifacts'
  }
  use { 
    'ms-jpq/coq.thirdparty', 
    branch= '3p'
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
    requires = { {'nvim-lua/plenary.nvim'} }
  }

  -- Treesitter
  use {
      'nvim-treesitter/nvim-treesitter',
      run = ':TSUpdate'
  }

  -- Fugitive
  use 'tpope/vim-fugitive'

  -- -- LSP
  -- use 'neovim/nvim-lspconfig'

  -- LSP TS Utils
  use {
      'jose-elias-alvarez/nvim-lsp-ts-utils',
      requires = {
          {'neovim/nvim-lspconfig'},
          {'nvim-lua/plenary.nvim'},
          {'jose-elias-alvarez/null-ls.nvim'}
      }
  }

  -- Code Action Menu
  use {
    'weilbith/nvim-code-action-menu',
    cmd = 'CodeActionMenu',
  }

  -- Focus
  use {
      'beauwilliams/focus.nvim',
      config = function()
          require('focus').setup({compatible_filetrees = {'CHADTree'}, treewidth = 20})
      end
  }
  
  -- Toggleterm
  use 'akinsho/toggleterm.nvim'

end)
