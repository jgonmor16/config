# config

My personal configuration files: Neovim and zsh, installed by symlinking
into place with `make`.

| Target | Effect |
|---|---|
| `make nv` | Link the Neovim config into `~/.config/nvim` |
| `make zsh` | Link `zsh/` to `~/.config/zsh` and `zsh/.zshenv` to `~/.zshenv` |
| `make clean` | Remove every link above |
| `make check` | Load Neovim headlessly and syntax-check every zsh file |

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
treesitter  lsp  gitsigns  diagnostics  completion  hdlsnip
```

`health` is not required at startup; `:checkhealth user` loads it.

### Requirements

- Neovim ≥ 0.12 (for `vim.pack`, `vim.lsp.config`/`vim.lsp.enable`,
`vim.o.autocomplete`, `vim.o.winborder`)
- `git`, `curl` (or `wget`) and a C compiler — used by `vim.pack`, Mason and
the Treesitter parser builds
- [`tree-sitter-cli`](https://github.com/tree-sitter/tree-sitter) ≥ 0.26.1 on
`$PATH` — used to build Treesitter parsers (auto-installed via Mason)
- A system clipboard tool — `wl-clipboard` on Wayland, `xclip`/`xsel` on
X11, or `win32yank` on WSL (see [WSL](#wsl))

Run `:checkhealth user` to confirm all of the above.

### Installation

```bash
make nv
```

This symlinks `nvim/init.lua` and `nvim/lua` into `~/.config/nvim` (creating
the directory if it doesn't exist).

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

## Zsh

Plain zsh, no framework. `~/.zshenv` sets `ZDOTDIR=~/.config/zsh`, so the
rest of the config and all state follow the XDG layout: history in
`~/.local/state/zsh/`, the completion dump in `~/.cache/zsh/`.

### Layout

| File | Concern |
|---|---|
| `.zshenv` | Environment for every zsh: XDG paths, `ZDOTDIR`, `EDITOR`, `PATH` |
| `.zshrc` | Sources the modules below in order |
| `options.zsh` | History, directory and misc options, `LS_COLORS` |
| `completion.zsh` | `compinit`, fully re-scanned at most once a day |
| `keybinds.zsh` | Vi mode |
| `prompt.zsh` | `vcs_info` prompt |
| `aliases.zsh` | `ls`/`grep` defaults and git aliases (oh-my-zsh names) |
| `plugins.zsh` | Autosuggestions and syntax highlighting — must stay last |

### Requirements

- zsh (tested on 5.9)
- `zsh-autosuggestions` and `zsh-syntax-highlighting` from the distro
(`apt install` or `pacman -S`, same package names); either is skipped if
missing

### Installation

```bash
make zsh && exec zsh
```

`make zsh` refuses to run if `~/.config/zsh` is a real directory, since
`ln -sfn` would nest the link inside it. Remove `~/.zshenv` to fall back to
`~/.zshrc`.

### Prompt

```
➜ [user] repo/subdir git:(branch|action) ✗ + ?
```

Inside a repo the path starts at the repo root; outside it is relative to
`~` when under it, otherwise absolute. The arrow turns red after a failing
command. `✗` marks unstaged changes, `+`
staged changes and `?` untracked files; `action` appears only during a
rebase, merge or similar.

### Vi mode

Insert mode, the default, keeps the usual emacs keys, so normal mode is
opt-in. The cursor is a beam in insert mode and a block in normal mode.

| Key | Mode | Action |
|---|---|---|
| `<Esc>` | Insert | Normal mode |
| `i` `a` `I` `A` | Normal | Back to insert mode |
| `b` `w` `e` `0` `$` | Normal | Move by word / to line start or end |
| `f` `t` `F` `T`, `;` | Normal | Jump to a character, repeat the jump |
| `cw` `dw` `ci"` `da(` `yib` … | Normal | Operators with text objects |
| `u` | Normal | Undo |
| `/` `?`, `n` | Normal | Search history, next match |
| `↑` `↓`, `^P` `^N` | Both | History matching the typed prefix |
| `^R` / `^S` | Insert | Incremental history search back / forward |
| `^A` / `^E` | Insert | Start / end of line |
| `^W` / `^U` | Insert | Delete word / to line start |
| `^X^E` | Both | Edit the command line in `$EDITOR` |
| `→`, `^E` | Insert | Accept the autosuggestion |

`bindkey -M vicmd` lists every normal-mode binding.

## WSL

Notes for running this config under WSL, outside the repo:

- **Clipboard** — put
[`win32yank.exe`](https://github.com/equalsraf/win32yank) on the Windows
drive (e.g. `%USERPROFILE%\bin`) and symlink it into `~/.local/bin`. Nvim
resolves the link, and Windows starts the binary much faster from its own
drive than through the WSL file share.
- **Terminal** — Windows' built-in ConPTY drops bracketed paste and mouse
reporting. For Alacritty, copy `conpty.dll` and `OpenConsole.exe` from the
[`Microsoft.Windows.Console.ConPTY`](https://www.nuget.org/packages/Microsoft.Windows.Console.ConPTY)
package next to `alacritty.exe`; Windows Terminal ships them already.
