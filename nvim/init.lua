---------------------------------------------------------------------------
-- Options
---------------------------------------------------------------------------
vim.o.number = true
vim.o.relativenumber = true
vim.o.wrap = false
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.swapfile = false
vim.o.expandtab = true
vim.o.cursorline = true
vim.o.colorcolumn = "80"
vim.o.winborder = "rounded"
vim.o.scrolloff = 3
vim.o.clipboard = "unnamedplus"

-- Solve +q4D73 known glitch
local termfeatures = vim.g.termfeatures or {}
termfeatures.osc52 = false
vim.g.termfeatures = termfeatures

-- Wrap git commit message bodies at column 71 (the conventional Git limit)
vim.api.nvim_create_autocmd("FileType", {
    pattern = "gitcommit",
    callback = function()
        vim.opt_local.textwidth = 71
    end,
})

---------------------------------------------------------------------------
-- Keymaps
---------------------------------------------------------------------------
vim.g.mapleader = " "

vim.keymap.set('n', '<leader>o', function()
    vim.cmd("update")
    vim.cmd("source %")
end, { desc = "Save & reload config" })
vim.keymap.set('n', '<leader>w', ':write<CR>', { desc = "Save file" })
vim.keymap.set('n', '<leader>x', ':x<CR>', { desc = "Save and close file" })
vim.keymap.set('n', '<leader>lf', vim.lsp.buf.format,
    { desc = "Format buffer via LSP" })

---------------------------------------------------------------------------
-- Plugins
---------------------------------------------------------------------------
vim.pack.add({
    { src = "https://github.com/neovim/nvim-lspconfig" },
    { src = "https://github.com/mason-org/mason.nvim" },
    { src = "https://github.com/maxmx03/solarized.nvim" },
    { src = "https://github.com/nvim-treesitter/nvim-treesitter",
      version = "main" },
})

---------------------------------------------------------------------------
-- Solarized Theme
---------------------------------------------------------------------------
vim.o.termguicolors = true
vim.o.background = "dark"

require("solarized").setup({})
vim.cmd.colorscheme("solarized")

---------------------------------------------------------------------------
-- Treesitter
---------------------------------------------------------------------------
require("nvim-treesitter").install({
    "lua",
    "vim",
    "vimdoc",
    "markdown",
    "bash",
    "python",
    "yaml",
    "toml",
})

vim.api.nvim_create_autocmd("FileType", {
    callback = function()
        pcall(vim.treesitter.start)
    end,
})

---------------------------------------------------------------------------
-- LSP
---------------------------------------------------------------------------
require("mason").setup()
local mason_registry = require("mason-registry")

-- List of Mason and LSP servers
local servers = {
    { mason = "lua-language-server", lsp = "lua_ls" },
    { mason = "basedpyright", lsp = "basedpyright" },
    { mason = "ruff", lsp = "ruff" },
    { mason = "taplo", lsp = "taplo" },
    { mason = "yaml-language-server", lsp = "yamlls" },
}

-- tree-sitter-clie is not a language server (no lspconfig entry)
local ensure_installed = { "tree-sitter-cli" }
local lsp_names = {}
for _, server in ipairs(servers) do
    table.insert(ensure_installed, server.mason)
    table.insert(lsp_names, server.lsp)
end

mason_registry.refresh(function()
    for _, name in ipairs(ensure_installed) do
        local ok, pkg = pcall(mason_registry.get_package, name)
        if ok and not pkg:is_installed() then
            pkg:install()
        end
    end
end)

vim.lsp.enable(lsp_names)

-- Fix 'vim' global warning
vim.lsp.config("lua_ls", {
    settings = {
        Lua = {
            workspace = {
                library = vim.api.nvim_get_runtime_file("", true),
            }
        }
    }
})

---------------------------------------------------------------------------
-- Completion
---------------------------------------------------------------------------
vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(ev)
        local client = vim.lsp.get_client_by_id(ev.data.client_id)
        if client and client:supports_method('textDocument/completion') then
            vim.lsp.completion.enable(true, client.id, ev.buf, {
                autotrigger = true,
            })
        end
    end,
})

vim.opt.completeopt:append("noselect")

vim.keymap.set("i", "<C-j>", function()
    return vim.fn.pumvisible() == 1 and "<C-n>" or "<C-j>"
end, { expr = true, desc = "Completion: next" })

vim.keymap.set("i", "<C-k>", function()
    return vim.fn.pumvisible() == 1 and "<C-p>" or "<C-k>"
end, { expr = true, desc = "Completion: previous" })
