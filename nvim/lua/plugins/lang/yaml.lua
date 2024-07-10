return {
	{
		"nvim-treesitter/nvim-treesitter",
		opts = function(_, opts)
			require("utils.extend-ensure-installed")(opts, {
				"yaml"
			})
		end
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
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		opts = function(_, opts)
			require("utils.extend-ensure-installed")(opts, {
				"prettierd"
			})
		end
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
