vim.lsp.enable("lua_ls")

return {
	{
		"nvim-treesitter/nvim-treesitter",
		opts = {
			ensure_installed = {
				"lua"
			}
		}
	},
	{
		"williamboman/mason.nvim",
		opts = {
			ensure_installed = {
				"lua-language-server"
			}
		}
	}
}
