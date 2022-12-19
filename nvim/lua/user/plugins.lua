-------------------------------------------------------------------------------
-- Plugins Configuration
-------------------------------------------------------------------------------


-------------
-- Lualine --
-------------
require 'user.lualine'

--------------
-- Comments --
--------------
require 'user.comment'

---------------
-- Blankline --
---------------
require('indent_blankline').setup {
  char = '┊',
  show_trailing_blankline_indent = false,
}

--------------
-- Gitsigns --
--------------
require('gitsigns').setup {
  signs = {
  add = { text = '+' },
  change = { text = '~' },
  delete = { text = '_' },
  topdelete = { text = '‾' },
  changedelete = { text = '~' },
  },
}

---------------
-- Telescope --
---------------
require 'user.telescope'

----------------
-- Treesitter --
----------------
require 'user.treesitter'

---------
-- LSP --
---------
require 'user.lsp'

----------------
-- Completion --
----------------
require 'user.completion'


