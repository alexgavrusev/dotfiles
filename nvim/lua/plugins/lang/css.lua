vim.lsp.enable("cssls")
vim.lsp.enable("tailwindcss")

return {
	{
		"nvim-treesitter/nvim-treesitter",
		opts = {
			ensure_installed = {
				"css",
				"scss"
			}
		}
	},
	{
		"williamboman/mason.nvim",
		opts = {
			ensure_installed = {
				"css-lsp",
				"tailwindcss-language-server",
				"prettierd"
			}
		}
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
