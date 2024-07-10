return {
	{
		"nvim-treesitter/nvim-treesitter",
		opts = function(_, opts)
			require("utils.extend-ensure-installed")(opts, {
				"astro"
			})
		end
	},
	{
		"neovim/nvim-lspconfig",
		opts = {
			servers = {
				astro = {}
			}
		}
	},
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		opts = function(_, opts)
			require("utils.extend-ensure-installed")(opts, {
				"prettierd",
				"eslint_d",
			})
		end
	},
	{
		"stevearc/conform.nvim",
		opts = function(_, opts)
			require("utils.conform").configure_prettier(opts, {
				"astro"
			})
		end,
	},
	{
		"mfussenegger/nvim-lint",
		opts = function(_, opts)
			require("utils.nvim-lint").configure_eslint(opts, {
				"astro"
			})
		end,
	}
}
