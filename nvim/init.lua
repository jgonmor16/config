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
vim.o.mouse = "a"

-- Solve +q4D73 known glitch
local termfeatures = vim.g.termfeatures or {}
termfeatures.osc52 = false
vim.g.termfeatures = termfeatures

-- Briefly highlight yanked text (built in since 0.11 as vim.hl.on_yank)
vim.api.nvim_create_autocmd("TextYankPost", {
    group = vim.api.nvim_create_augroup("user.yank", { clear = true }),
    desc = "Briefly highlight yanked text",
    callback = function()
        vim.hl.on_yank()
    end,
})

-- Wrap git commit message bodies at column 71 (the conventional Git limit)
vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("user.gitcommit", { clear = true }),
    desc = "Wrap gitcommit bodies at the conventional 71 columns",
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
    group = vim.api.nvim_create_augroup("user.treesitter", { clear = true }),
    desc = "Start treesitter when a parser exists for the filetype",
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
    { mason = "verible",              lsp = "verible" },
    { mason = "rust_hdl",             lsp = "vhdl_ls" },
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
    group = vim.api.nvim_create_augroup("user.diagnostics", { clear = true }),
    desc = "Drop per-buffer diagnostic severity state",
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
-- Core sets 'omnifunc' to the LSP client on attach, so adding "o" to
-- 'complete' is all that's needed to merge LSP results into the other
-- ins-completion sources.
vim.opt.complete:append("o")
vim.opt.completeopt = { "menu", "menuone", "noinsert", "popup" }
vim.o.autocomplete = true

-- <CR> always breaks the line, even with the menu open
vim.keymap.set("i", "<CR>", function()
    return vim.fn.pumvisible() == 1 and "<C-e><CR>" or "<CR>"
end, { expr = true, desc = "Newline (never confirm completion)" })

vim.keymap.set("i", "<C-j>", function()
    return vim.fn.pumvisible() == 1 and "<C-n>" or "<C-j>"
end, { expr = true, desc = "Completion: next" })

vim.keymap.set("i", "<C-k>", function()
    return vim.fn.pumvisible() == 1 and "<C-p>" or "<C-k>"
end, { expr = true, desc = "Completion: previous" })

-- Accept the current match, or the first one if the menu opened unselected
-- ('autocomplete' forces "noselect" on the non-LSP path; see :h 'autocomplete').
vim.keymap.set("i", "<C-y>", function()
    if vim.fn.pumvisible() == 0 then
        return "<C-y>"
    end
    return vim.fn.complete_info({ "selected" }).selected == -1
        and "<C-n><C-y>" or "<C-y>"
end, { expr = true, desc = "Completion: accept (first match if none selected)" })
