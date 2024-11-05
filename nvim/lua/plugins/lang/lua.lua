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
		"neovim/nvim-lspconfig",
		opts = {
			servers = {
				lua_ls = {}
			}
		}
	}
}
