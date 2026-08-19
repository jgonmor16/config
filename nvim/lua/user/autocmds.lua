---------------------------------------------------------------------------
-- Editor autocommands
--
-- Autocommands tied to a specific subsystem live with it: user.treesitter,
-- user.lsp and user.diagnostics each own their own augroup.
---------------------------------------------------------------------------

-- vim.hl.on_yank() is built in; the autocmd that calls it is not.
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
        vim.opt_local.colorcolumn = { "71" }
    end,
})

-- Web ecosystems, and Prettier in particular, assume two-space indentation.
vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("user.indent", { clear = true }),
    desc = "Use two-space indentation for web filetypes",
    pattern = { "html", "css", "javascript", "typescript", "json", "jsonc" },
    callback = function()
        vim.opt_local.tabstop = 2
        vim.opt_local.shiftwidth = 2
    end,
})
