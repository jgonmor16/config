---------------------------------------------------------------------------
-- Editor keymaps
--
-- <leader> and <localleader> are set in init.lua. Subsystem maps live with
-- their module: LSP maps in user.lsp, completion maps in user.completion,
-- the diagnostic toggle in user.diagnostics.
---------------------------------------------------------------------------
vim.keymap.set('n', '<leader>o', function()
    vim.cmd("update")
    for name in pairs(package.loaded) do
        if name == "user" or name:find("^user%.") then
            package.loaded[name] = nil
        end
    end
    vim.cmd.source(vim.env.MYVIMRC)
    vim.notify("Config reloaded", vim.log.levels.INFO)
end, { desc = "Save & reload config" })

vim.keymap.set('n', '<leader>w', '<cmd>write<CR>', { desc = "Save file" })
vim.keymap.set('n', '<leader>x', '<cmd>x<CR>', { desc = "Save and close file" })

-- Re-indent without losing the visual selection: `gv` reselects the last
-- visual area, so you can press < / > repeatedly to keep shifting.
vim.keymap.set('v', '<', '<gv', { desc = "Indent left, keep selection" })
vim.keymap.set('v', '>', '>gv', { desc = "Indent right, keep selection" })
