---------------------------------------------------------------------------
-- Options
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

-- Solve +q4D73 known glitch
local termfeatures = vim.g.termfeatures or {}
termfeatures.osc52 = false
vim.g.termfeatures = termfeatures

-- Briefly highlight yanked text (built in since 0.11 as vim.hl.on_yank)
vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
        vim.hl.on_yank()
    end,
})

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
vim.keymap.set('n', '<leader>w', '<cmd>write<CR>', { desc = "Save file" })
vim.keymap.set('n', '<leader>x', '<cmd>x<CR>', { desc = "Save and close file" })
vim.keymap.set('n', '<leader>lf', vim.lsp.buf.format,
    { desc = "Format buffer via LSP" })

-- Re-indent without losing the visual selection: `gv` reselects the last
-- visual area, so you can press < / > repeatedly to keep shifting.
vim.keymap.set('v', '<', '<gv', { desc = "Indent left, keep selection" })
vim.keymap.set('v', '>', '>gv', { desc = "Indent right, keep selection" })

---------------------------------------------------------------------------
-- Plugins
---------------------------------------------------------------------------
vim.pack.add({
    { src = "https://github.com/neovim/nvim-lspconfig" },
    { src = "https://github.com/mason-org/mason.nvim" },
    { src = "https://github.com/maxmx03/solarized.nvim" },
    {
        src = "https://github.com/nvim-treesitter/nvim-treesitter",
        version = "main"
    },
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
    { mason = "lua-language-server",  lsp = "lua_ls" },
    { mason = "basedpyright",         lsp = "basedpyright" },
    { mason = "ruff",                 lsp = "ruff" },
    { mason = "taplo",                lsp = "taplo" },
    { mason = "yaml-language-server", lsp = "yamlls" },
}

-- tree-sitter-clie is not a language server (no lspconfig entry)
local ensure_installed = { "tree-sitter-cli" }
local lsp_names = {}
for _, server in ipairs(servers) do
    table.insert(ensure_installed, server.mason)
    table.insert(lsp_names, server.lsp)
end

-- Ensure every tool above is actually installed.
mason_registry.refresh(function()
    for _, name in ipairs(ensure_installed) do
        local ok, pkg = pcall(mason_registry.get_package, name)
        if ok and not pkg:is_installed() then
            pkg:install()
        end
    end
end)

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

vim.lsp.enable(lsp_names)

---------------------------------------------------------------------------
-- Diagnostic
---------------------------------------------------------------------------
local warnings_hidden = {}

local function severity_filter(_, bufnr)
    if warnings_hidden[bufnr] ~= false then
        return { severity = vim.diagnostic.severity.ERROR }
    end
    return {} -- no filter: show every severity
end

-- Drop per-buffer state when the buffer goes away, so the table can't grow
-- unbounded over a long session.
vim.api.nvim_create_autocmd("BufDelete", {
    callback = function(ev)
        warnings_hidden[ev.buf] = nil
    end,
})

vim.diagnostic.config({
    severity_sort = true,
    virtual_text = severity_filter,
    signs = severity_filter,
    underline = severity_filter,
})

vim.keymap.set("n", "<leader>lw", function()
    local bufnr = vim.api.nvim_get_current_buf()
    local hidden = warnings_hidden[bufnr] ~= false
    warnings_hidden[bufnr] = not hidden
    vim.diagnostic.show(nil, bufnr) -- force an immediate redraw with the new state
    vim.notify(
        warnings_hidden[bufnr] and "Warnings hidden (errors only)" or "Warnings shown",
        vim.log.levels.INFO
    )
end, { desc = "Toggle warning diagnostics (this buffer)" })


---------------------------------------------------------------------------
-- Completion
---------------------------------------------------------------------------
-- Point 'omnifunc' at the LSP client so its results can be merged with other
-- sources below.
vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(ev)
        local client = vim.lsp.get_client_by_id(ev.data.client_id)
        if client and client:supports_method('textDocument/completion') then
            vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"
        end
    end,
})

vim.opt.complete:append("o")
vim.opt.completeopt = { "menu", "menuone", "noinsert", "popup" }

local just_completed = false
vim.api.nvim_create_autocmd("CompleteDone", {
    callback = function()
        just_completed = true
    end,
})

-- Only pop the menu up once you've typed at least 3 characters of the
-- current word — avoids a menu after every single keystroke.
vim.api.nvim_create_autocmd("TextChangedI", {
    callback = function()
        if just_completed then
            just_completed = false
            return
        end
        if vim.fn.pumvisible() == 1 then
            return -- already open; typing further just narrows it natively
        end
        local col = vim.fn.col(".")
        local before_cursor = vim.fn.getline("."):sub(1, col - 1)
        local word = before_cursor:match("[%w_]+$") or ""
        if #word >= 3 then
            local keys = vim.api.nvim_replace_termcodes("<C-n>", true, false, true)
            vim.api.nvim_feedkeys(keys, "n", false)
        end
    end,
})

vim.keymap.set("i", "<C-j>", function()
    return vim.fn.pumvisible() == 1 and "<C-n>" or "<C-j>"
end, { expr = true, desc = "Completion: next" })

vim.keymap.set("i", "<C-k>", function()
    return vim.fn.pumvisible() == 1 and "<C-p>" or "<C-k>"
end, { expr = true, desc = "Completion: previous" })
