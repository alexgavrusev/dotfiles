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
	map("n", "<CR>", ":let @/=''<CR>:echo ' '<CR><CR>", { silent = true })

	-- https://www.reddit.com/r/neovim/comments/12pqkjo/comment/jgn0lct
	map("n", "<", "<<", { silent = true, desc = "Outdent" })
	map("n", ">", ">>", { silent = true, desc = "Indent" })
	map("v", "<", "<gv", { silent = true, desc = "Outdent" })
	map("v", ">", ">gv", { silent = true, desc = "Indent" })
end

M.bufferline = {
	{ "<leader>bp", "<cmd>BufferLinePick<cr>", desc = "[B]uffer [p]ick" }
}

M.bufdel = {
	{ "<leader>bd", "<cmd>BufDel<CR>",       desc = "[B]uffer [d]elete" },
	{ "<leader>bD", "<cmd>BufDelOthers<CR>", desc = "[B]uffer [d]elete all other" },
}

M.mini_files = {
	{
		"<leader>e",
		function()
			require("mini.files").open(vim.api.nvim_buf_get_name(0), true)
		end,
		desc = "Open explorer in directory of current file (mini.files)"
	},
	{
		"<leader>E",
		function()
			require("mini.files").open(vim.uv.cwd(), true)
		end,
		desc = "Open explorer in cwd (mini.files)",
	},
}

M.trouble = {
	{
		"<leader>xx",
		"<cmd>Trouble diagnostics toggle<cr>",
		desc = "Diagnostics (Trouble)",
	},
	{
		"<leader>xX",
		"<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
		desc = "Buffer Diagnostics (Trouble)",
	},
	{
		"<leader>xt",
		"<cmd>Trouble telescope toggle focus=true<cr>",
		desc = "Telescope search results (Trouble)",
	},
}

M.conform = {
	{
		"<leader>p",
		function()
			require("conform").format({ async = true, lsp_format = "fallback" })
		end,
		desc = "Format buffer",
	},
}

M.telescope = {
	{ "<leader>ff", "<cmd>Telescope find_files<cr>",                    desc = "Find file" },
	{ "<leader>fg", "<cmd>Telescope live_grep<cr>",                     desc = "Live grep" },
	{ "<leader>fk", "<cmd>Telescope keymaps<cr>",                       desc = "Keymaps" },
	{ "<leader>fw", "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", desc = "Dynamic workspace symbols" },
	{ "<leader>fd", "<cmd>Telescope lsp_document_symbols<cr>",          desc = "Document symbols" },
	{
		"<leader>fs",
		require("plugins.telescope-config.fuzzy_search").current_file_fuzzy,
		desc = "Current file fuzzy search"
	},
}

M.lsp_buffer = function(buffer)
	local map = function(modes, lhs, rhs, opts)
		if type(opts) == "string" then
			desc = opts;
			opts = { desc = desc }
		end

		vim.keymap.set(modes, lhs, rhs, vim.tbl_extend("keep", opts, { buffer = buffer }))
	end

	map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
	map("n", "<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
	map("n", "gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
	map("n", "gd", "<cmd>Telescope lsp_definitions<CR>", "[G]oto [D]efinition")
	map("n", "gi", "<cmd>Telescope lsp_implementations<CR>", "[G]oto [I]mplementation")
	map("n", "<leader>D", "<cmd>Telescope lsp_type_definitions<CR>", "Type [D]efinition")
	map("n", "gr", "<cmd>Telescope lsp_references<CR>", "[G]oto [R]eferences")
	map("n", "K", vim.lsp.buf.hover, "Hover Documentation")
	map("i", "<C-k>", vim.lsp.buf.signature_help, "Signature Documentation")
end

return M
