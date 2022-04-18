local o = vim.opt
local g = vim.g
local map = vim.api.nvim_set_keymap

map('i', '<C-]>', '<Esc>', {})

map('n', '<Space>', '', {})
g.mapleader = " "
g.maplocalleader = " "

g.do_filetype_lua = true

o.number = true
o.relativenumber = true
o.signcolumn = "yes"

o.tabstop = 4
o.softtabstop = 4
o.shiftwidth = 4
o.expandtab = true
o.smartindent = true

o.smartcase = true
o.incsearch = true

o.hidden = true
o.updatetime = 750
o.termguicolors = true
o.shortmess = o.shortmess + "c"

o.shell = "/bin/bash"
