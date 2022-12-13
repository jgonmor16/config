----------------
-- Neorg Conf --
----------------

local status_ok, neorg = pcall(require, "neorg")
if not status_ok then
    return
end

-- Neorg setup
neorg.setup({
    load = {
        -- All default modules
        ["core.defaults"] = {},
        -- Icons stuff
        ["core.norg.concealer"] = {
            config = {
                fold = false,
            }
        },
        -- Completion Engine
        ["core.norg.completion"] = {
            config = {
                engine = "nvim-cmp"
            }
        },
        ["core.norg.qol.toc"] = {},
        ["core.norg.dirman"] = {
            config = {
                workspaces = {
                    work = "~/notes/work",
                    gtd = "~/todo",
                }
            }
        },
        -- Get Things Done
        ["core.gtd.base"] = {
            config = {
                workspace = "gtd",
            }
        },
    }
})

-- TODO: Investigate issue with this

-- local parser_configs = require("nvim-treesitter.parsers").get_parser_configs()
--
-- parser_configs.norg = {
--     install_info = {
--         url = "https://github.com/vhyrro/tree-sitter-norg",
--         files = { "src/parser.c" },
--         branch = "main",
--     },
-- }
