vim.lsp.enable("yamlls")

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
		"williamboman/mason.nvim",
		opts = {
			ensure_installed = {
				"yaml-language-server",
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
