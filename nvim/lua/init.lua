--------------
-- init.lua --
--------------

-- Common conf
vim.cmd("syntax on")
vim.cmd("filetype indent plugin on")
vim.cmd("colorscheme solarized")        -- Solarized colorscheme

-- Require all the lua conf files
require("plugins")              -- Plugins
require("option")               -- Options
require("setup")                -- Setup
require("mapping")              -- Keybindings
require("lsp")                  -- LSP configuration
require("completion")           -- cmp configuration
require("treesitter")           -- Treesitter configuration
require("comment")              -- Comment configuration

