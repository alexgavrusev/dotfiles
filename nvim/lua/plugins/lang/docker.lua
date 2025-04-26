vim.lsp.enable("dockerls")
vim.lsp.enable("docker_compose_language_service")

return {
	{
		"nvim-treesitter/nvim-treesitter",
		opts = {
			ensure_installed = {
				"dockerfile"
			}
		}
	},
	{
		"williamboman/mason.nvim",
		opts = {
			ensure_installed = {
				"docker-langserver",
				"docker-compose-langserver"
			}
		}
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
