vim.lsp.enable("graphql")

return {
	{
		"nvim-treesitter/nvim-treesitter",
		opts = {
			ensure_installed = {
				"graphql"
			}
		}
	},
	{
		"williamboman/mason.nvim",
		opts = {
			ensure_installed = {
				"graphql-lsp",
				"prettierd"
			}
		}
	},
	{
		"stevearc/conform.nvim",
		opts = function(_, opts)
			require("utils.conform").configure_prettier(opts, {
				"graphql",
			})
		end,
	},
}
