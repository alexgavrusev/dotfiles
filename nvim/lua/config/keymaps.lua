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
end

M.lsp_buffer = function(buffer)
	local map = function(modes, lhs, rhs, opts)
		if type(opts) == "string" then
			desc = opts;
			opts = { desc = desc }
		end

		vim.keymap.set(modes, lhs, rhs, vim.tbl_extend("keep", opts, { buffer = buffer }))
	end

	-- Taken from https://github.com/Jlchong3/config.nvim/blob/60c96804ab201077d02eff9455950d2532fe46c3/lua/custom/lsp.lua#L139
	-- Also see https://github.com/echasnovski/mini.nvim/issues/978#issuecomment-2428497300
	local on_list = function(opts)
		local previous = vim.fn.getqflist()

		vim.fn.setqflist({}, " ", opts)
		if #opts.items == 1 then
			vim.cmd.cfirst()
		else
			require("mini.extra").pickers.list({ scope = "quickfix" }, { source = { name = opts.title } })
		end

		vim.fn.setqflist(previous, " ")
	end

	map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
	map("n", "<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
	map("n", "gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

	map("n", "gd", function() vim.lsp.buf.definition({ on_list = on_list }) end, "[G]oto [D]efinition")
	map("n", "gi", function() vim.lsp.buf.implementation({ on_list = on_list }) end, "[G]oto [I]mplementation")
	map("n", "<leader>D", function() vim.lsp.buf.type_definition({ on_list = on_list }) end, "Type [D]efinition")
	map("n", "gr", function() vim.lsp.buf.references(nil, { on_list = on_list }) end, "[G]oto [R]eferences")
	map("n", "K", vim.lsp.buf.hover, "Hover Documentation")
	map("i", "<C-k>", vim.lsp.buf.signature_help, "Signature Documentation")
end

return M
