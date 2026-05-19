return {
	{
		"neovim/nvim-lspconfig",
		opts = {
			servers = {
				basedpyright = {},
				ruff = {},
			},
		},
	},
	{
		"nvim-treesitter/nvim-treesitter",
		opts = {
			ensure_installed = { "python" }
		}
	},
	{
		"williamboman/mason.nvim",
		opts = {
			ensure_installed = {
				"basedpyright",
				"ruff",
			}
		}
	},
	{
		"stevearc/conform.nvim",
		opts = {
			formatters_by_ft = {
				python = { "ruff_format", "ruff_organize_imports" },
			}
		}
	},
}
