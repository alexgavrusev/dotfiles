local M = {}

local map = vim.keymap.set;

M.init = function()
	vim.g.mapleader = " "

	-- easier window navigation
	map("n", "<C-H>", "<C-W>h")
	map("n", "<C-J>", "<C-W>j")
	map("n", "<C-K>", "<C-W>k")
	map("n", "<C-L>", "<C-W>l")

	-- clearing highlights - https://vi.stackexchange.com/a/252
	-- clear selection, then clear the command line, then do the actual <CR>
	map("n", "<Esc>", ":let @/=''<CR>:echo ' '<CR>", { silent = true })

	-- https://www.reddit.com/r/neovim/comments/12pqkjo/comment/jgn0lct
	map("n", "<", "<<", { silent = true, desc = "Outdent" })
	map("n", ">", ">>", { silent = true, desc = "Indent" })
	map("v", "<", "<gv", { silent = true, desc = "Outdent" })
	map("v", ">", ">gv", { silent = true, desc = "Indent" })


	-- picker used for document symbols instead
	vim.keymap.del("n", "gO")
end

return M
