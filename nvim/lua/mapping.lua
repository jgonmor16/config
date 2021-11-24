--------------
-- Keybinds --
--------------

-------------------------------------------------------------------------------

local map = vim.api.nvim_set_keymap
local cmd = vim.cmd
local g = vim.g

-------------------------------------------------------------------------------

-- Common options
local opts = {noremap = true, silent = true}

-- Keybindings
-- map('<mode>', '<key>', '<KeyCombToExpand>', opts)

-- Move line mappings
map('n', '<c-j>', ':m .+1<CR>==', opts)
map('n', '<c-k>', ':m .-2<CR>==', opts)
