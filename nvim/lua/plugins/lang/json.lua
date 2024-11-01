return {
	{
		"nvim-treesitter/nvim-treesitter",
		opts = function(_, opts)
			require("utils.extend-ensure-installed")(opts, {
				"json",
				"jsonc"
			})
		end
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
		opts = function(_, opts)
			require("utils.extend-ensure-installed")(opts, {
				"prettierd",
			})
		end
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
