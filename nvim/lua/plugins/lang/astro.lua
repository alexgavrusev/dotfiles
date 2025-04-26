vim.lsp.enable("astro")

return {
	{
		"nvim-treesitter/nvim-treesitter",
		opts = {
			ensure_installed = {
				"astro"
			}
		}
	},
	{
		"williamboman/mason.nvim",
		opts = {
			ensure_installed = {
				"astro-language-server",
				"prettierd"
			}
		}
	},
	{
		"stevearc/conform.nvim",
		opts = function(_, opts)
			require("utils.conform").configure_prettier(opts, {
				"astro"
			})
		end,
	}
}
