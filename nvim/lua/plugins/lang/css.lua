return {
	{
		"nvim-treesitter/nvim-treesitter",
		opts = function(_, opts)
			require("utils.extend-ensure-installed")(opts, {
				"css",
				"scss"
			})
		end
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
		"WhoIsSethDaniel/mason-tool-installer.nvim",
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
				"css",
				"scss"
			})
		end,
	},
}
