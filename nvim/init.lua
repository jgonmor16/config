-------------------------------------------------------------------------------
-- init.lua --
-------------------------------------------------------------------------------

---------------------
-- Handy variables --
---------------------

-- Packer Plugins
local fn = vim.fn
local cmd = vim.cmd

cmd('filetype plugin on')

--------------------
-- Packer Install --
--------------------

-- Check if packer is installed. Otherwise, install it
local install_path = vim.fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'
local is_bootstrap = false

if fn.empty(fn.glob(install_path)) > 0 then
  is_bootstrap = true
  fn.execute('!git clone https://github.com/wbthomason/packer.nvim ' .. install_path)
  cmd [[packadd packer.nvim]]
end

--------------------------
-- Packer Configuration --
--------------------------
require('packer').startup(function(use)

  -- Packer (can handle itself)
  use 'wbthomason/packer.nvim'

  -----------------------
  -- LSP configuration --
  -----------------------
  use {
    'neovim/nvim-lspconfig',
    requires = {
      -- Install LSPs to stdpath for neovim
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',

      -- Status updates for LSP
      'j-hui/fidget.nvim',
    },
  }

  --------------------
  -- Autocompletion --
  --------------------
  use {
    'hrsh7th/nvim-cmp',
    requires = {
      -- cmp-lsp
      use 'hrsh7th/cmp-nvim-lsp',
      -- Snippets
      use 'L3MON4D3/LuaSnip',
      use 'saadparwaiz1/cmp_luasnip',
      -- Buffer and files
      use 'hrsh7th/cmp-buffer',
      use 'hrsh7th/cmp-path'
    },
  }
  -- Cool icons for LSP
  use 'onsails/lspkind-nvim'

  -- Review
  --use 'hrsh7th/cmp-nvim-lua'        -- Lua

  ----------------
  -- Treesitter --
  ----------------
  -- [INFO]: highlight, edit and navigate code
  use {
    'nvim-treesitter/nvim-treesitter',
    run = function()
      pcall(require('nvim-treesitter.install').update { with_sync = true })
    end,
  }

  -- Aditional text objects via treesitter
  use {
    'nvim-treesitter/nvim-treesitter-textobjects',
    after = 'nvim-treesitter',
  }

  ---------
  -- Git --
  ---------
  use 'lewis6991/gitsigns.nvim'

  -- TODO: check this plugins
  -- use 'tpope/vim-fugitive'
  -- use 'tpope/vim-rhubarb'

  ------------------------------------
  -- Solarized theme and Statusline --
  ------------------------------------
  use {
    'svrana/neosolarized.nvim',
    requires = {
      'tjdevries/colorbuddy.nvim'
    }
  }
  use {
    'nvim-lualine/lualine.nvim',
    requires = {
      'kyazdani42/nvim-web-devicons',
      opt = true
    }
  }

  -- Really cool plugin which automatically detects tabstop and shiftwidth
  use 'tpope/vim-sleuth'

  ---------------
  -- Telescope --
  ---------------
  -- Fuzzy finder (files, lsp, etc)
  use {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    requires = {
      'nvim-lua/plenary.nvim'
    },
  }
  -- Fuzzy Finder Algorithm which requires local dependencies to be built.
  -- Only load if `make` is available
  use {
    'nvim-telescope/telescope-fzf-native.nvim',
    run = 'make',
    cond = fn.executable 'make' == 1
  }

  --------------
  -- Comments --
  --------------
  use 'numToStr/Comment.nvim'

  -- Add indentation guides even on blank lines
  use 'lukas-reineke/indent-blankline.nvim'

  -- Neorg
  use {
    'nvim-neorg/neorg',
    tag = '*',              -- Latest Stable Version
    run = ':Neorg sync-parsers',
    requires = 'nvim-lua/plenary.nvim'
  }


  -- TODO: Review this
  local has_plugins, plugins = pcall(require, 'custom.plugins')
  if has_plugins then
    plugins(use)
  end

  if is_bootstrap then
    require('packer').sync()
  end

end)

-- When we are bootstrapping a configuration, it doesn't
-- make sense to execute the rest of the init.lua.
--
-- You'll need to restart nvim, and then it will work.
if is_bootstrap then
  print '=================================='
  print '   Plugins are being installed'
  print '   Wait until Packer completes,'
  print '       then restart nvim'
  print '=================================='
  return
end

-- Automatically source and re-compile packer whenever this file is saved
local packer_group = vim.api.nvim_create_augroup('Packer', { clear = true })
vim.api.nvim_create_autocmd('BufWritePost', {
  command = 'source <afile> | PackerSync',
  group = packer_group,
  pattern = fn.expand '$MYVIMRC',
})

------------------------
-- Nvim Configuration --
------------------------

-- Disable builtin plugins I do not use
require 'user.disable_buildtin'
-- Options
require 'user.option'
-- Keybindings
require 'user.mapping'

---------------------------
-- Plugins Configuration --
---------------------------

-- Configure plugins added above
require 'user.plugins'

