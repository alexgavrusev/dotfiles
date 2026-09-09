return {
	{
		"neovim/nvim-lspconfig",
		opts = {
			servers = {
				lua_ls = {},
			},
		},
	},
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
