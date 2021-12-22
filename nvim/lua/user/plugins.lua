-------------
-- Plugins --
-------------

-------------------------------------------------------------------------------

local fn = vim.fn
local cmd = vim.cmd

cmd("filetype plugin on")

-- Automatically install packer
local install_path = fn.stdpath("data").."/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
    PACKER_BOOTSTRAP = fn.system {
        "git",
        "clone",
        "--depth",
        "1",
        "https://github.com/wbthomason/packer.nvim",
        install_path,
    }
    print "Installing packer. Close and reopen nvim..."
    cmd [[packadd packer.nvim]]
end

-- Reload nvim whenever this file is saved
cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]])

local status_ok, packer = pcall(require, "packer")
if not status_ok then
    return
end

packer.init {
    display = {
        open_fn = function()
            return require("packer.util").float { border = "rounded" }
        end,
    },
}

-------------------------------------------------------------------------------

-- Packer
return packer.startup(function(use)

    -- Packer
    use "wbthomason/packer.nvim"

    -- Useful lua functions used ny lots of plugins
    use "nvim-lua/plenary.nvim"
    -- An implementation of the Popup API from vim in Neovim
    use "nvim-lua/popup.nvim"

    -- Airline (theme)
    use "vim-airline/vim-airline"
    use "vim-airline/vim-airline-themes"

    -- Completion and LSP
    use "neovim/nvim-lspconfig"             -- LSP
    use "hrsh7th/nvim-cmp"                  -- cmp autocompletion
    use "hrsh7th/cmp-buffer"                -- Buffer
    use "hrsh7th/cmp-path"                  -- Files
    use "hrsh7th/cmp-nvim-lua"              -- Lua
    use "hrsh7th/cmp-nvim-lsp"              -- cmp-LSP
    use "saadparwaiz1/cmp_luasnip"          -- luasnip
    use "onsails/lspkind-nvim"              -- Cool icons
    use "williamboman/nvim-lsp-installer"   -- LSP Installer

    -- Treesitter
    use {
        "nvim-treesitter/nvim-treesitter",
        run = ":TSUpdate"
    }

    -- Snip
    use "L3MON4D3/LuaSnip"

    -- Comments
    use "numToStr/Comment.nvim"

    -- Telescope
    use "nvim-telescope/telescope.nvim"
        -- requires = { {"nvim-lua/plenary.nvim"} }

    -- Automatically set up config after cloning packer
    if PACKER_BOOTSTRAP then
        require("packer").sync()
    end

end)
