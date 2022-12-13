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
-- map("<mode>", "<key>", "<KeyCombToExpand>", opts)

-- NORMAL --
-- Window navigation
map("n", "<C-h>", "<C-w>h", opts)
--map("n", "<C-j>", "<C-w>j", opts)
--map("n", "<C-k>", "<C-w>k", opts)
map("n", "<C-l>", "<C-w>l", opts)

-- New window
map("n", "<leader>e", ":Lex 30<CR>", opts)
map("n", "<leader>n", ":vnew<CR>", opts)
map("n", "<leader>q", ":q<CR>", opts)
map("n", "<leader>1", ":q!<CR>", opts)
map("n", "<leader>x", ":wq<CR>", opts)

-- Move line mappings
map("n", "<S-j>", ":m .+1<CR>==", opts)
map("n", "<S-k>", ":m .-2<CR>==", opts)

-- Resize with arrows
map("n", "<C-Up>", ":resize +2<CR>", opts)
map("n", "<C-Down>", ":resize -2<CR>", opts)
map("n", "<C-Left>", ":vertical resize -2<CR>", opts)
map("n", "<C-Right>", ":vertical resize +2<CR>", opts)

-- Navigate buffers
map("n", "<S-l>", ":bnext<CR>", opts)
map("n", "<S-h>", ":bprevious<CR>", opts)

-- Stop hightights after search
map("n", "<leader>o", ":noh<CR>", opts)

-- INSERT --
map("i", "jk", "<ESC>", opts)

-- VISUAL
-- Stay in indent mode
map("v", "<", "<gv", opts)
map("v", ">", ">gv", opts)

-- Telescope Mappings
-- keymap("n", "<leader>f", "<cmd>Telescope find_files<cr>", opts)
map("n", "<leader>f", "<cmd>lua require'telescope.builtin'.find_files(require('telescope.themes').get_dropdown({ previewer = false }))<cr>", opts)
map("n", "<c-t>", "<cmd>Telescope live_grep<cr>", opts)

-- Hightights
-- Stop them after search (when pressing <ESC>)
map("n", "<ESC>", ":noh<CR><ESC>", opts)

-- NEORG
map("n", "gtv", ":Neorg gtd views<CR>", opts)
map("n", "gtc", ":Neorg gtd capture<CR>", opts)
map("n", "gte", ":Neorg gtd edit<CR>", opts)
