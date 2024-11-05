return {
	{
		"nvim-treesitter/nvim-treesitter",
		opts = {
			ensure_installed = {
				"yaml"
			}
		}
	},
	{
		"neovim/nvim-lspconfig",
		opts = {
			servers = {
				yamlls = {}
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
				"yaml"
			})
		end,
	},
}
