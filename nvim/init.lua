---------------------------------------------------------------------------
-- Neovim configuration entry point.
--
-- Leaders are set first so that every mapping defined further down picks
-- them up. Module order matters: user.plugins puts the plugin directories
-- on the runtimepath, so anything that requires a plugin must follow it.
---------------------------------------------------------------------------
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

require("user.options")
require("user.autocmds")
require("user.keymaps")
require("user.plugins")
require("user.colorscheme")
require("user.treesitter")
require("user.lsp")
require("user.gitsigns")
require("user.diagnostics")
require("user.completion")
require("user.hdlsnip")
