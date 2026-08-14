---------------------------------------------------------------------------
-- Editor options
---------------------------------------------------------------------------
vim.o.number = true
vim.o.relativenumber = true
vim.o.wrap = false
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true
vim.o.cursorline = true
vim.o.colorcolumn = "80"
vim.o.winborder = "rounded"
vim.o.scrolloff = 3
vim.o.clipboard = "unnamedplus"
vim.o.signcolumn = "yes"
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.mouse = "a"
vim.o.undofile = true

vim.o.termguicolors = true
vim.o.background = "dark"

-- Solve +q4D73 known glitch
local termfeatures = vim.g.termfeatures or {}
termfeatures.osc52 = false
vim.g.termfeatures = termfeatures
