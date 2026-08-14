---------------------------------------------------------------------------
-- Git signs
--
-- Buffer maps are created in on_attach so they only exist in buffers that
-- are actually tracked by git.
---------------------------------------------------------------------------
require("gitsigns").setup({
    on_attach = function(bufnr)
        local gs = require("gitsigns")

        local function map(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
        end

        -- ]c and [c are the builtin diff-mode motions, so defer to them
        -- when the window is in diff mode and only navigate hunks otherwise.
        map("n", "]c", function()
            if vim.wo.diff then
                vim.cmd.normal({ "]c", bang = true })
            else
                gs.nav_hunk("next")
            end
        end, "Git: next hunk")

        map("n", "[c", function()
            if vim.wo.diff then
                vim.cmd.normal({ "[c", bang = true })
            else
                gs.nav_hunk("prev")
            end
        end, "Git: previous hunk")

        map("n", "<leader>gs", gs.stage_hunk, "Git: stage hunk")
        map("n", "<leader>gr", gs.reset_hunk, "Git: reset hunk")

        map("v", "<leader>gs", function()
            gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, "Git: stage selected lines")

        map("v", "<leader>gr", function()
            gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, "Git: reset selected lines")

        map("n", "<leader>gS", gs.stage_buffer, "Git: stage buffer")
        map("n", "<leader>gR", gs.reset_buffer, "Git: reset buffer")
        map("n", "<leader>gp", gs.preview_hunk, "Git: preview hunk")
        map("n", "<leader>gd", gs.diffthis, "Git: diff against index")

        map("n", "<leader>gb", function()
            gs.blame_line({ full = true })
        end, "Git: blame line")

        map({ "o", "x" }, "ih", gs.select_hunk, "Git hunk")
    end,
})
