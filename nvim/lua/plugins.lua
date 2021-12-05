-------------
-- Plugins --
-------------

-------------------------------------------------------------------------------

-- Plugins
vim.cmd("filetype plugin on")
vim.cmd [[packadd packer.nvim]]

-------------------------------------------------------------------------------

-- Packer
return require("packer").startup(function()

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
    --use "dense-analysis/ale"

    -- Treesitter
    use {
        "nvim-treesitter/nvim-treesitter",
        run = ":TSUpdate"
    }

    -- Snip
    --use ""

    -- Comments
    use "numToStr/Comment.nvim"

end)
