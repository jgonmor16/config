------------------------
-- LSP Installer Conf --
------------------------

local status_ok, lsp_installer = pcall(require, "nvim-lsp-installer")
if not status_ok then
    return
end

-- Register a handler that will be called for all installer servers
-- Alternatively, you may also register handlers on specific server instances
-- instead (see example below)
lsp_installer.on_server_ready(function(server)
    local opts = {
        on_attach = require("user.lsp.handlers").on_attach,
        capabilities = require("user.lsp.handlers").capabilities,
    }
    if server.name == "sumneko_lua" then
        local lua_opts = require("user.lsp.settings.lua")
        opts = vim.tbl_deep_extend("force", lua_opts, opts)
    end

    -- This setup() function is exactly the same as the lspconfig's setup
    -- function. Refer to:
    -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
    server:setup(opts)
end)
