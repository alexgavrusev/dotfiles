return {
	{
		"nvim-treesitter/nvim-treesitter",
		opts = function(_, opts)
			require("utils.extend-ensure-installed")(opts, {
				"dockerfile"
			})
		end
	},
	{
		"neovim/nvim-lspconfig",
		opts = {
			servers = {
				dockerls = {},
				docker_compose_language_service = {}
			}
		}
	}
}
