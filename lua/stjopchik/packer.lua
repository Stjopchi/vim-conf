-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  use {
	  'nvim-telescope/telescope.nvim', tag = '0.1.6',
	  -- or                            , branch = '0.1.x',
	  requires = { {'nvim-lua/plenary.nvim'} }
  }

  use { 'catppuccin/nvim', as = 'catppuccin' }
   
  use('nvim-treesitter/nvim-treesitter', {run = ':TSUpdate'})
  
  use 'nvim-lua/plenary.nvim' -- don't forget to add this one if you don't have it yet!
  use {
    'ThePrimeagen/harpoon',
    branch = 'harpoon2',
    requires = { 'nvim-lua/plenary.nvim' }
  }

  use('mbbill/undotree')
  use('tpope/vim-fugitive')

  use({
    'williamboman/mason.nvim',
    'williamboman/mason-lspconfig.nvim',
    'neovim/nvim-lspconfig',
  })
  
  use('hrsh7th/nvim-cmp')
  use('hrsh7th/cmp-nvim-lsp')
  use('hrsh7th/cmp-buffer')
  use('hrsh7th/cmp-path')
  use('saadparwaiz1/cmp_luasnip')
  use('L3MON4D3/LuaSnip')
  use('rafamadriz/friendly-snippets')
  use('j-hui/fidget.nvim')

  use {
      'nvim-lualine/lualine.nvim',
      requires = { 'nvim-tree/nvim-web-devicons', opt = true }
  }
end)
