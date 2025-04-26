vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.g.have_nerd_font = true

vim.opt.termguicolors = true

-- show relative line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Don't show the mode, since it's already in the status line
vim.opt.showmode = false

-- Sync clipboard between OS and Neovim.
--  Schedule the setting after `UiEnter` because it can increase startup-time.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.schedule(function()
	vim.opt.clipboard = 'unnamedplus'
end)

-- Save undo history
vim.opt.undofile = true
vim.opt.undolevels = 5000

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default
vim.opt.signcolumn = "yes"

-- Decrease update time
vim.opt.updatetime = 250

-- Decrease mapped sequence wait time
vim.opt.timeoutlen = 300

-- Preview substitutions live, as you type!
vim.opt.inccommand = 'split'

-- Show which line your cursor is on
vim.opt.cursorline = true

-- vertical blinking cursor in insert mode
vim.opt.guicursor = "i:ver1-blinkon100"

-- allow cursor to move where there is no text in visual block mode
vim.opt.virtualedit = "block"

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 10

-- use 2 spaces instead of tab
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2

-- use rounded borders on all floating windows
vim.o.winborder = "rounded"
