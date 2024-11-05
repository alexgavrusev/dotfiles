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
		"neovim/nvim-lspconfig",
		opts = {
			servers = {
				ts_ls = {}
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
				"javascript",
				"javascriptreact",
				"typescript",
				"typescriptreact",
			})
		end,
	},
}
