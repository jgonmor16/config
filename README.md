
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
    - `verible` — SystemVerilog/Verilog
    - `vhdl_ls` — VHDL (Mason package `rust_hdl`)
- **Completion** — built-in `'autocomplete'`, merging LSP omni results with
the standard buffer sources; no completion plugin required
- **Diagnostics** — errors only by default, warnings toggled per buffer
- **Clipboard** — synced with the system clipboard (`unnamedplus`)
- **Health check** — `:checkhealth user` verifies the version, external
tooling, plugins, parsers and Mason packages

### Layout
`nvim/init.lua` sets the leaders and requires the modules in order. Each
module under `nvim/lua/user/` owns one concern, and each keeps its own
`user.*` autocommand group so reloading replaces handlers instead of
stacking them:

```
options  autocmds  keymaps  plugins  colorscheme
treesitter  lsp  gitsigns  diagnostics  completion  health
```

### Requirements

- Neovim ≥ 0.12 (for `vim.pack`, `vim.lsp.config`/`vim.lsp.enable`,
`vim.o.autocomplete`, `vim.o.winborder`)
- `git`, `curl` (or `wget`) and a C compiler — used by `vim.pack`, Mason and
the Treesitter parser builds
- [`tree-sitter-cli`](https://github.com/tree-sitter/tree-sitter) ≥ 0.26.1 on
`$PATH` — used to build Treesitter parsers (auto-installed via Mason)
- A system clipboard tool — `xclip`/`xsel` on X11, or `wl-clipboard` on
Wayland (unless relying on OSC 52)

Run `:checkhealth user` to confirm all of the above.

### Installation

```bash
make nv
```

This symlinks `nvim/init.lua` and `nvim/lua` into `~/.config/nvim` (creating
the directory if it doesn't exist). Run `make clean` to remove them, or
`make check` to load the config headlessly and fail on any error.

Then start Neovim. Plugins, Treesitter parsers, and LSP tools install
themselves on first launch (this may take a minute the very first time).

### Key bindings

Leader is `<Space>`. LSP and Git maps are buffer-local, and only exist where
a capable server is attached or the file is tracked.

#### Editor

| Key | Mode | Action |
|---|---|---|
| `<leader>o` | Normal | Save and reload the config |
| `<leader>w` | Normal | Save file |
| `<leader>x` | Normal | Save and quit |
| `<leader>n` | Normal | Split window vertically |
| `<C-h>` / `<C-l>` | Normal | Move to the window left / right |
| `<Esc>` | Normal | Clear search highlight |
| `<` / `>` | Visual | Indent, keeping the selection |

#### LSP and diagnostics

| Key | Mode | Action |
|---|---|---|
| `gd` / `gD` | Normal | Go to definition / declaration |
| `<leader>lf` | Normal | Format buffer via LSP |
| `<leader>lw` | Normal | Toggle warnings in this buffer |

Neovim's own defaults (`grn`, `gra`, `grr`, `gri`, `grt`, `gO`, `K`) apply as
usual.

#### Completion

| Key | Mode | Action |
|---|---|---|
| `<C-j>` / `<C-k>` | Insert | Next / previous suggestion |
| `<C-y>` | Insert | Accept, taking the first match if none is selected |
| `<CR>` | Insert | Newline — never confirms a completion |

#### Git

| Key | Mode | Action |
|---|---|---|
| `]c` / `[c` | Normal | Next / previous hunk |
| `<leader>gs` / `<leader>gr` | Normal, Visual | Stage / reset hunk |
| `<leader>gS` / `<leader>gR` | Normal | Stage / reset buffer |
| `<leader>gp` | Normal | Preview hunk |
| `<leader>gd` | Normal | Diff against index |
| `<leader>gb` | Normal | Blame line |
| `ih` | Operator, Visual | Hunk text object |

