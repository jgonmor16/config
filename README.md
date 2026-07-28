
# config

My personal configuration files.

## Neovim

A minimal, modern Neovim setup (`nvim/init.lua`) built entirely on Neovim's
own built-in tools — no third-party plugin manager (`lazy.nvim`, `packer`,
etc.), just `vim.pack`.

### Features

- **Plugin management** — [`vim.pack`](https://neovim.io/doc/user/pack.html),
Neovim's built-in package manager
- **Colorscheme** — [Solarized Dark](https://github.com/maxmx03/solarized.nvim)
by [Ethan Schoonover](https://ethanschoonover.com/solarized/), with Treesitter
and semantic-highlight support
- **Syntax highlighting** —
[nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter)
(`main` branch)
- **LSP** — native `vim.lsp` (`vim.lsp.config` / `vim.lsp.enable`), servers
managed by [Mason](https://github.com/mason-org/mason.nvim):
    - `lua_ls` — Lua
    - `basedpyright` — Python type checking
    - `ruff` — Python linting/formatting
    - `taplo` — TOML
    - `yamlls` — YAML
- **Completion** — built-in LSP completion (`vim.lsp.completion`), no
completion plugin required
- **Clipboard** — synced with the system clipboard (`unnamedplus`)

### Requirements

- Neovim ≥ 0.12 (for `vim.pack`, `vim.lsp.config`/`vim.lsp.enable`,
`vim.o.winborder`)
- [`tree-sitter-cli`](https://github.com/tree-sitter/tree-sitter) ≥ 0.26.1 on
`$PATH` — used to build Treesitter parsers (auto-installed via Mason)
- A system clipboard tool — `xclip`/`xsel` on X11, or `wl-clipboard` on
Wayland (unless relying on OSC 52)

### Installation

```bash
make nv
```

This symlinks `nvim/init.lua` to `~/.config/nvim/init.lua` (creating the
directory if it doesn't exist). Run `make clean` to remove the symlink.

Then start Neovim. Plugins, Treesitter parsers, and LSP tools install
themselves on first launch (this may take a minute the very first time).

### Key bindings

| Key | Mode | Action |
|---|---|---|
| `<Space>` | — | Leader key |
| `<leader>o` | Normal | Save and reload `init.lua` |
| `<leader>w` | Normal | Save file |
| `<leader>x` | Normal | Save and quit |
| `<leader>lf` | Normal | Format buffer via LSP |
| `<C-j>` / `<C-k>` | Insert | Next / previous completion suggestion |
| `<C-y>` | Insert | Confirm completion (native, no mapping needed) |
