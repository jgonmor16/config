--------------
-- init.lua --
--------------

-- Common conf
vim.cmd("syntax on")
vim.cmd("filetype indent plugin on")
vim.cmd("colorscheme solarized")        -- Solarized colorscheme

-- Require all the lua conf files
require "user.plugins"               -- Plugins
require "user.option"                -- Options
require "user.mapping"               -- Keybindings
require "user.telescope"             -- Telescope configuration
require "user.completion"            -- cmp configuration
require "user.lsp"                   -- LSP configuration
require "user.treesitter"            -- Treesitter configuration
require "user.comment"               -- Comment configuration
require "user.luasnippets"           -- Snippets configuration

