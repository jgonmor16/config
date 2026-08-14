---------------------------------------------------------------------------
-- Completion
---------------------------------------------------------------------------

-- Core sets 'omnifunc' to the LSP client on attach, so "o" is all that is
-- needed to merge LSP results into the other ins-completion sources. Set
-- the full list (default is .,w,b,u,t) rather than appending, so reloading
-- the config cannot stack duplicate flags.
vim.opt.complete = { ".", "w", "b", "u", "t", "o" }
vim.opt.completeopt = { "menu", "menuone", "noinsert", "popup" }
vim.o.autocomplete = true

-- <CR> always breaks the line, even with the menu open
vim.keymap.set("i", "<CR>", function()
    return vim.fn.pumvisible() == 1 and "<C-e><CR>" or "<CR>"
end, { expr = true, desc = "Newline (never confirm completion)" })

-- 'autocomplete' forces "noselect" on the typing-triggered path, so the
-- menu can open with nothing highlighted; the LSP omnifunc path honours
-- "noinsert" and does preselect. Normalise both to "take the top match".
vim.keymap.set("i", "<C-y>", function()
    if vim.fn.pumvisible() == 0 then
        return "<C-y>"
    end
    return vim.fn.complete_info({ "selected" }).selected == -1
        and "<C-n><C-y>" or "<C-y>"
end, { expr = true, desc = "Completion: accept (first match if none selected)" })

vim.keymap.set("i", "<C-j>", function()
    return vim.fn.pumvisible() == 1 and "<C-n>" or "<C-j>"
end, { expr = true, desc = "Completion: next" })

vim.keymap.set("i", "<C-k>", function()
    return vim.fn.pumvisible() == 1 and "<C-p>" or "<C-k>"
end, { expr = true, desc = "Completion: previous" })
