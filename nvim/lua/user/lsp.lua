---------------------------------------------------------------------------
-- LSP
---------------------------------------------------------------------------
require("mason").setup()
local mason_registry = require("mason-registry")

-- List of Mason and LSP servers
local servers = {
    { mason = "lua-language-server",    lsp = "lua_ls" },
    { mason = "basedpyright",           lsp = "basedpyright" },
    { mason = "ruff",                   lsp = "ruff" },
    { mason = "taplo",                  lsp = "taplo" },
    { mason = "yaml-language-server",   lsp = "yamlls" },
    { mason = "verible",                lsp = "verible" },
    { mason = "rust_hdl",               lsp = "vhdl_ls" },
    { mason = "rust-analyzer",          lsp = "rust_analyzer" },
    { mason = "html-lsp",               lsp = "html" },
    { mason = "css-lsp",                lsp = "cssls" },
    { mason = "clangd",                 lsp = "clangd" },
    { mason = "bash-language-server",   lsp = "bashls" },
    { mason = "json-lsp",               lsp = "jsonls" },
    { mason = "jdtls",                  lsp = "jdtls" },
    { mason = "kotlin-language-server", lsp = "kotlin_language_server" },
    { mason = "lemminx",                lsp = "lemminx" },
    {
        mason = "typescript-language-server",
        lsp = "ts_ls",
    },
}

-- tree-sitter-cli is not a language server (no lspconfig entry)
local ensure_installed = { "tree-sitter-cli" }
local lsp_names = {}
for _, server in ipairs(servers) do
    table.insert(ensure_installed, server.mason)
    table.insert(lsp_names, server.lsp)
end

-- Ensure every tool above is actually installed, and report when the
-- background installs finish. get_package() raises on an unknown name and
-- install() asserts when one is already running, so both are guarded.
mason_registry.refresh(function(success)
    if not success then
        vim.schedule(function()
            vim.notify("Mason: registry refresh failed; see :MasonLog",
                vim.log.levels.ERROR)
        end)
        return
    end

    local queue = {}

    for _, name in ipairs(ensure_installed) do
        if not mason_registry.has_package(name) then
            vim.schedule(function()
                vim.notify(("Mason: unknown package %q"):format(name),
                    vim.log.levels.ERROR)
            end)
        else
            local pkg = mason_registry.get_package(name)
            if not pkg:is_installed()
                and not pkg:is_installing()
                and not pkg:is_uninstalling()
            then
                table.insert(queue, pkg)
            end
        end
    end

    if #queue == 0 then
        return
    end

    local remaining, failed = #queue, {}
    for _, pkg in ipairs(queue) do
        pkg:install(nil, function(ok)
            if not ok then
                table.insert(failed, pkg.name)
            end

            remaining = remaining - 1
            if remaining > 0 then
                return
            end

            vim.schedule(function()
                if #failed == 0 then
                    vim.notify(("Mason: installed %d tool(s)"):format(#queue),
                        vim.log.levels.INFO)
                else
                    vim.notify(
                        "Mason: install failed for " .. table.concat(failed, ", ")
                        .. " (see :Mason)",
                        vim.log.levels.WARN)
                end
            end)
        end)
    end
end)

-- Fix 'vim' global warning
vim.lsp.config("lua_ls", {
    settings = {
        Lua = {
            workspace = {
                library = vim.api.nvim_get_runtime_file("", true),
            }
        }
    }
})

vim.lsp.enable(lsp_names)

vim.keymap.set('n', '<leader>lf', vim.lsp.buf.format,
    { desc = "Format buffer via LSP" })

-- Nvim's default LSP maps cover grn/gra/grr/gri/grt/gO/K but deliberately
-- leave gd and gD as the builtin keyword searches. Override them per
-- buffer, and only where the server answers the method, so buffers
-- without a capable server keep the builtin behaviour.
vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("user.lsp", { clear = true }),
    desc = "Map gd/gD when the attached server supports them",
    callback = function(ev)
        local client = vim.lsp.get_client_by_id(ev.data.client_id)
        if not client then
            return
        end

        local methods = vim.lsp.protocol.Methods

        if client:supports_method(methods.textDocument_definition) then
            vim.keymap.set("n", "gd", vim.lsp.buf.definition,
                { buffer = ev.buf, desc = "LSP: go to definition" })
        end

        if client:supports_method(methods.textDocument_declaration) then
            vim.keymap.set("n", "gD", vim.lsp.buf.declaration,
                { buffer = ev.buf, desc = "LSP: go to declaration" })
        end
    end,
})

return {
    servers = servers,
    ensure_installed = ensure_installed,
}
