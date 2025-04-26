vim.lsp.enable("ts_ls")
vim.lsp.enable("eslint")

return {
	{
		"nvim-treesitter/nvim-treesitter",
		opts = {
			ensure_installed = {
				"javascript",
				"typescript",
				"tsx",
			}
		}
	},
	{
		"williamboman/mason.nvim",
		opts = {
			ensure_installed = {
				"typescript-language-server",
				"eslint-lsp",
				"prettierd"
			}
		}
	},
	{
		"stevearc/conform.nvim",
		opts = function(_, opts)
			require("utils.conform").configure_prettier(opts, {
				"javascript",
				"javascriptreact",
				"typescript",
				"typescriptreact",
			})
		end,
	},
}
