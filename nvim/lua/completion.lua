---------------
-- cmp Setup --
---------------

local cmp_status_ok, cmp = pcall(require, "cmp")
if not cmp_status_ok then
    return
end

local snip_status_ok, luasnip = pcall(require, "luasnip")
if not snip_status_ok then
    return
end

local lspkind = require "lspkind"

cmp.setup {
    mapping = {
        ["<C-k>"] = cmp.mapping.select_prev_item(),
        ["<C-j>"] = cmp.mapping.select_next_item(),
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-e>"] = cmp.mapping.close(),
        ["<C-y>"] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Insert,
            select = true
        },
        -- Show all the posibilities
        ["<C-Space>"] = cmp.mapping.complete(),
    },
    -- Sources are ordered by priority
    sources = {
        { name = "nvim_lua" },
        { name = "nvim_lsp" },
        { name = "path" },
        { name = "luasnip" },
        { name = "buffer", keyword_length = 5 },
        --{ name = "gh_issues" },
        -- Config options:
            -- keyword_length
            -- priority
            -- max_item_count
    },
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    formatting = {
	format = function(entry, vim_item)
	    -- fancy icons and a name of kind
	    vim_item.kind = require("lspkind").presets.default[vim_item.kind] .. " " .. vim_item.kind
	    -- set a name for each source
            vim_item.menu = ({
                buffer = "[Buf]",
                nvim_lsp = "[LSP]",
                nvim_lua = "[Lua]",
                path = "[Path]",
                luasnip = "[LuaSnip]",
                --gh_issues = "[issues]",
                --latex_symbols = "[Latex]",
            })[entry.source.name]
            return vim_item
        end,
    },
    experimental = {
        native_menu = false,
        ghost_text = false, -- Show ghost completion
    },
}

