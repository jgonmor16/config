---------------------------------------------------------------------------
-- :checkhealth user
--
-- Verifies the prerequisites this config assumes: a new enough Neovim, the
-- module tree being reachable, the external binaries Mason and treesitter
-- shell out to, and whether the declared tooling actually landed on disk.
---------------------------------------------------------------------------
local health = vim.health

local M = {}

local MODULES = {
    "options",
    "autocmds",
    "keymaps",
    "plugins",
    "colorscheme",
    "treesitter",
    "lsp",
    "gitsigns",
    "diagnostics",
    "completion",
}

local function check_version()
    health.start("Neovim version")

    local version = tostring(vim.version())
    if vim.fn.has("nvim-0.12") == 1 then
        health.ok("Neovim " .. version)
    else
        health.error("Neovim " .. version .. " is too old", {
            "This config uses vim.pack and 'autocomplete', both 0.12+.",
        })
    end
end

local function check_modules()
    health.start("Config modules")

    local missing = {}
    for _, name in ipairs(MODULES) do
        if not package.loaded["user." .. name] then
            table.insert(missing, name)
        end
    end

    if #missing == 0 then
        health.ok(("all %d user modules loaded"):format(#MODULES))
    else
        health.error("not loaded: " .. table.concat(missing, ", "), {
            "~/.config/nvim/lua must link to nvim/lua in the repo.",
            "Run `make nv` from the repository root.",
        })
    end
end

local function check_executables()
    health.start("External tools")

    if vim.fn.executable("curl") == 1 then
        health.ok("curl")
    elseif vim.fn.executable("wget") == 1 then
        health.warn("curl not found, Mason will fall back to wget")
    else
        health.error("neither curl nor wget found", {
            "Mason cannot download its registry without one of them.",
        })
    end

    if vim.fn.executable("git") == 1 then
        health.ok("git")
    else
        health.error("git not found", {
            "vim.pack and gitsigns both shell out to git.",
        })
    end

    if vim.fn.executable("node") == 1 then
        health.ok("node")
    else
        health.error("node not found", {
            "The html, css, json and typescript servers are npm packages.",
        })
    end

    local compiler
    for _, cc in ipairs({ "cc", "gcc", "clang" }) do
        if vim.fn.executable(cc) == 1 then
            compiler = cc
            break
        end
    end

    if compiler then
        health.ok("C compiler (" .. compiler .. ")")
    else
        health.error("no C compiler found", {
            "treesitter compiles each parser from source.",
        })
    end

    if vim.fn.executable("tree-sitter") == 1 then
        health.ok("tree-sitter")
    else
        health.warn("tree-sitter CLI not found", {
            "Mason installs it as tree-sitter-cli; check :Mason.",
        })
    end
end

local function check_plugins()
    health.start("Plugins")

    local ok, plugins = pcall(vim.pack.get, nil, { info = false })
    if not ok or #plugins == 0 then
        health.warn("no plugins reported by vim.pack.get()")
        return
    end

    for _, plugin in ipairs(plugins) do
        if plugin.active then
            health.ok(plugin.spec.name)
        else
            health.warn(plugin.spec.name .. " on disk but not active", {
                "Left behind by a removed vim.pack.add() entry.",
                "Remove it with vim.pack.del({ '" .. plugin.spec.name .. "' }).",
            })
        end
    end
end

local function check_parsers()
    health.start("Treesitter parsers")

    local ok, treesitter = pcall(require, "user.treesitter")
    if not ok then
        health.error("could not load user.treesitter")
        return
    end

    local missing = {}
    for _, lang in ipairs(treesitter.parsers) do
        local found = vim.api.nvim_get_runtime_file("parser/" .. lang .. ".*", false)
        if #found == 0 then
            table.insert(missing, lang)
        end
    end

    if #missing == 0 then
        health.ok(("all %d parsers compiled"):format(#treesitter.parsers))
    else
        health.warn("not compiled: " .. table.concat(missing, ", "), {
            "Parsers install asynchronously; retry after a restart.",
        })
    end
end

local function check_mason()
    health.start("Mason packages")

    local registry_ok, registry = pcall(require, "mason-registry")
    local lsp_ok, lsp = pcall(require, "user.lsp")

    if not registry_ok or not lsp_ok then
        health.error("could not load mason-registry or user.lsp")
        return
    end

    for _, name in ipairs(lsp.ensure_installed) do
        if not registry.has_package(name) then
            health.error(name .. " is not in the registry", {
                "Either the name is wrong or the registry never downloaded.",
                "See :MasonLog.",
            })
        elseif registry.get_package(name):is_installed() then
            health.ok(name)
        else
            health.warn(name .. " not installed", { "See :Mason." })
        end
    end
end

function M.check()
    check_version()
    check_modules()
    check_executables()
    check_plugins()
    check_parsers()
    check_mason()
end

return M
