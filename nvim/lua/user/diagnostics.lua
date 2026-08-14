---------------------------------------------------------------------------
-- Diagnostics
--
-- Warnings are hidden per buffer by default; <leader>lw toggles them.
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
