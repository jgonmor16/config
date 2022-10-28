---------------------------
-- Options configuration --
---------------------------

-------------------------------------------------------------------------------

local g = vim.g         -- global variable
local opt = vim.opt     -- set options
local cmd = vim.cmd     -- vim command

-------------------------------------------------------------------------------

-- Enable dark background
opt.background = 'dark'
opt.termguicolors = true

-- Allow mouse use
opt.mouse = 'a'

-- Show number lines
opt.number = true
opt.relativenumber = true

-- Highlight the current line and column 80 as well
opt.cursorline = true
opt.colorcolumn = '80'

-- Show tab names, even if there is only one
opt.showtabline = 2

-- Hide status line unless there is more than one window
opt.laststatus = 1

-- Automatically convert tabs to spaces
opt.expandtab = true

-- Preserve indentation of previous line
opt.autoindent = true

-- keep 3 lines visible above/below the cursor when scrolling
opt.scrolloff = 3

-- Automatically wrap lines longer than 79 characters, except for git
-- commits, that must be only 71
--opt.tw = 79
cmd([[autocmd FileType gitcommit :setlocal tw=71]])

-- Show trailing whitepace and spaces before a tab
cmd([[highlight ExtraWhitespace ctermbg=red guibg=red]])
cmd([[autocmd Syntax * syn match ExtraWhitespace /\s\+$\| \+\ze\t/]])

-- Enable spell checker in LaTeX files
cmd([[autocmd FileType tex :setlocal spell spelllang=en_us]])

-- We want UTF-8 encoding for... pretty much everything modern.
opt.encoding = 'utf-8'

-- Indent scope declarations in C/C++ files
-- g: C++ scope declarations
-- h: statements after C++ scope declarations
-- i: C++ base class declarations and constructor initializations
-- :: case labels
-- =: statement after case label
cmd([[:set cino=g1,h7,i0,:1,=7']])

-- Enable indentation of all files, not only C, C++
-- vhdl
cmd([[autocmd FileType vhdl :setlocal shiftwidth=2]])
cmd([[autocmd FileType vhdl :setlocal softtabstop=2]])
g.vhdl_indent_genportmap = 0
g.vhdl_indent_rhsassign = 0
-- lua
cmd([[autocmd FileType lua :setlocal shiftwidth=4]])
cmd([[autocmd FileType lua :setlocal softtabstop=4]])
-- javascript
cmd([[autocmd FileType json :setlocal shiftwidth=2]])
cmd([[autocmd FileType json :setlocal softtabstop=2]])
-- c
cmd([[autocmd FileType c :setlocal shiftwidth=4]])
cmd([[autocmd FileType c :setlocal softtabstop=4]])
-- cpp
cmd([[autocmd FileType cpp :setlocal shiftwidth=4]])
cmd([[autocmd FileType cpp :setlocal softtabstop=4]])

-- Enable highlighting all the matches in incsearch mode
-- But don't enable hlsearch always
--cmd([[augroup vimrc-incsearch-highlight
--  autocmd!
--  autocmd CmdlineEnter [/\?] :set nohhlsearch
--  autocmd CmdlineLeave [/\?] :set lsearch
--augroup END
--]])

-------------------------------------------------------------------------------

-- Python Conf --

-- Figure out the system Python for Neovim.
cmd([[
if exists("$VIRTUAL_ENV")
    let g:python3_host_prog=substitute(system("which -a python3 | head -n2 | tail -n1"), "\n", '', 'g')
else
    let g:python3_host_prog=substitute(system("which python3"), "\n", '', 'g')
endif
]])

-- Highlight Python Stuff
g.python_highlight_all = 1

