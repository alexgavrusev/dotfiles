vim.opt.termguicolors = true

-- vertical blinking cursor in insert mode
vim.opt.guicursor = "i:ver1-blinkon100"

-- highlight cursor line
vim.opt.cursorline = true

-- show relative line numbers
vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.splitright = true

vim.opt.scrolloff = 8

vim.opt.signcolumn = "yes"

-- sync the unnamed (default) register with the system clipboard
vim.opt.clipboard = "unnamedplus"

-- allow cursor to move where there is no text in visual block mode
vim.opt.virtualedit = "block"

-- use 2 spaces instead of tab
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2

-- as per nvim-cmp instructions
vim.opt.completeopt = "menu,menuone,noselect"
