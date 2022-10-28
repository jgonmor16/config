--------------
-- init.lua --
--------------

-- Setup globals
require "user.global"

-- First load: check if packer is installed, otherwise install it
if require "user.first_load"() then
    return
end

if vim.g.neovide then
  vim.g.neovide_cursor_trail_legnth = 0
  vim.g.neovide_cursor_animation_length = 0
  vim.o.guifont = "Jetbrains Mono"
end

-- Remap space as leader key
vim.api.nvim_set_keymap("", "<Space>", "<Nop>", {noremap = true, silent = true})
vim.g.mapleader = " "

-- Disable builtin plugins I do not use
require "user.disable_buildtin"

-- Common conf
vim.cmd("syntax on")
vim.cmd("filetype indent plugin on")
vim.cmd("colorscheme solarized")        -- Solarized colorscheme

-- Neovim builtin LSP configuration
--require "user.lsp"

-- Telescope BTW
--require "user.telescope.setup"
--require "user.telescope.mappings"

-- Require all the lua conf files
require "user.plugins"              -- Plugins
require "user.option"               -- Options
require "user.mapping"              -- Keybindings
require "user.telescope"            -- Telescope configuration
require "user.completion"           -- cmp configuration
require "user.lsp"                  -- LSP configuration
require "user.treesitter"           -- Treesitter configuration
require "user.comment"              -- Comment configuration
require "user.luasnippets"          -- Snippets configuration
require "user.neorg"                -- Neorg configuration
require "user.lualine"              -- Status Line configuration

