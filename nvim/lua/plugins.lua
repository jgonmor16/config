-------------
-- Plugins --
-------------

-------------------------------------------------------------------------------

local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
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
    vim.cmd [[packadd packer.nvim]]
    vim.cmd("filetype plugin on")
end

-- Reload nvim whenever this file is saved
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]])

local status_ok, packer pcall(require, "packer")
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

    -- Airline (theme)
    use "vim-airline/vim-airline"
    use "vim-airline/vim-airline-themes"

    -- Completion
    use "neovim/nvim-lspconfig"     -- LSP
    use "hrsh7th/nvim-cmp"          -- cmp autocompletion
    use "hrsh7th/cmp-buffer"        -- Buffer
    use "hrsh7th/cmp-path"          -- Files
    use "hrsh7th/cmp-nvim-lua"      -- Lua
    use "hrsh7th/cmp-nvim-lsp"      -- LSP
    use "saadparwaiz1/cmp_luasnip"  -- luasnip
    use "onsails/lspkind-nvim"      -- Cool icons

    -- Treesitter
    use {
        "nvim-treesitter/nvim-treesitter",
        run = ":TSUpdate"
    }

    -- Snip
    --use ""

    -- Comments
    use "numToStr/Comment.nvim"

    -- Automatically set up config after clonign packer
    if PACKER_BOOTSTRAP then
        require("packer").sync()
    end

end)
