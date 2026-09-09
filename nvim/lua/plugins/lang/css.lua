return {
	{
		"neovim/nvim-lspconfig",
		opts = {
			servers = {
				cssls = {},
				tailwindcss = {},
			},
		},
	},
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
		"williamboman/mason.nvim",
		opts = {
			ensure_installed = {
				"css-lsp",
				"tailwindcss-language-server"
			}
		}
	},
	{
		"stevearc/conform.nvim",
		opts = function(_, opts)
			require("utils.conform").configure_oxfmt(opts, {
				"css",
				"scss"
			})
		end,
	},
}
