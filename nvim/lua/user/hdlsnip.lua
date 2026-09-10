---------------------------------------------------------------------------
-- HdlSnip.nvim
--
-- Parameterised VHDL templates for Neovim — entities, packages, clocked
-- processes and CDC synchronisers, rendered from Lua rather than pasted from a
-- static snippet file.
---------------------------------------------------------------------------
require("hdlsnip").setup({
  keys = {
    expand = "<C-k>",       -- expand a trigger, or jump forward in a snippet
    jump_prev = "<C-j>",
  },
})
