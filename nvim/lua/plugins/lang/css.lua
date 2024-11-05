return {
	{
		"nvim-treesitter/nvim-treesitter",
		opts = {
			ensure_installed = {
				"css",
				"scss"
			}
		}
	},
	{
		"neovim/nvim-lspconfig",
		opts = {
			servers = {
				cssls = {},
				tailwindcss = {},
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
				"css",
				"scss"
			})
		end,
	},
}
