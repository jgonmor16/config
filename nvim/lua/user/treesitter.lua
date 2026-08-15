---------------------------------------------------------------------------
-- Treesitter
---------------------------------------------------------------------------
local parsers = {
    "lua",
    "vim",
    "vimdoc",
    "markdown",
    "bash",
    "python",
    "yaml",
    "toml",
    "vhdl",
    "systemverilog",
}
require("nvim-treesitter").install(parsers)

-- Nvim detects .v as "verilog", but nvim-treesitter ships no parser under
-- that name and parser names are assumed to equal filetype names.
-- SystemVerilog is a superset, so point the filetype at it.
vim.treesitter.language.register("systemverilog", "verilog")

vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("user.treesitter", { clear = true }),
    desc = "Start treesitter when a parser exists for the filetype",
    callback = function()
        pcall(vim.treesitter.start)
    end,
})

return { parsers = parsers }
