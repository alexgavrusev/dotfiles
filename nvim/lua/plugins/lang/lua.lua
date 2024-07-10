return {
	{
		"nvim-treesitter/nvim-treesitter",
		opts = function(_, opts)
			require("utils.extend-ensure-installed")(opts, {
				"lua"
			})
		end
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
