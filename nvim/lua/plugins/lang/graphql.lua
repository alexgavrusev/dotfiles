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
		"neovim/nvim-lspconfig",
		opts = {
			servers = {
				graphql = {}
			}
		}
	},
	{
		"williamboman/mason.nvim",
		opts = {
			ensure_installed = {
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
