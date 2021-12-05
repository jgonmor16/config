--------------------
-- Comment config --
--------------------

require("Comment").setup {

    -- Add a space b/w comment and the line
    padding = true,

    -- Whether the cursor should stay at its position
    sticky = true,

    -- Lines to be ignored while comment/uncomment.
    --  Could be a regex string or a function that returns a regex string.
    --  Example: Use '^$' to ignore empty lines
    ignore = nil,

    -- LHS of toggle mappings in NORMAL + VISUAL mode
    toggler = {
        -- line-comment keymap
        line = 'gcc',
        -- block-comment keymap
        block = 'gbc',
    },

    -- LHS of operator-pending mappings in NORMAL + VISUAL mode
    opleader = {
        -- line-comment keymap
        line = 'gc',
        -- block-comment keymap
        block = 'gb',
    },

    -- Create basic (operator-pending) and extended mappings for NORMAL + VISUAL mode
    mappings = {

        -- operator-pending mapping
        -- Includes:
        -- `gcc`               -> line-comment the current line
        -- `gbc`               -> block-comment the current line
        -- `gc[count]{motion}` -> line-comment the region contained in {motion}
        -- `gb[count]{motion}` -> block-comment the region contained in {motion}
        basic = true,

        -- Extra mapping
        -- Includes `gco`, `gcO`, `gcA`
        extra = true,

        -- Extended mapping
        -- Includes `g>`, `g<`, `g>[count]{motion}` and `g<[count]{motion}`
        extended = false,
    },

    -- Pre-hook, called before commenting the line
    pre_hook = nil,

    -- Post-hook, called after commenting is done
    post_hook = nil,

}

local comment_ft = require "Comment.ft"
comment_ft.set("lua", {"--%s", "--[[%s]]"})
comment_ft.set("vhd", "--%s")
