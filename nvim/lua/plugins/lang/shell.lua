return {
	{
		"nvim-treesitter/nvim-treesitter",
		opts = function(_, opts)
			require("utils.extend-ensure-installed")(opts, {
				"bash"
			})
		end
	},
	{
		"neovim/nvim-lspconfig",
		opts = {
			servers = {
				bashls = {},
			}
		}
	}
}
