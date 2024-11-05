return {
	{
		"nvim-treesitter/nvim-treesitter",
		opts = {
			ensure_installed = {
				"json",
				"jsonc"
			}
		}
	},
	{
		"neovim/nvim-lspconfig",
		opts = {
			servers = {
				jsonls = {}
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
				"json",
				"jsonc"
			})
		end,
	},
}
