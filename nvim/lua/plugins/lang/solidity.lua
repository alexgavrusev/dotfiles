return {
	{
		"neovim/nvim-lspconfig",
		opts = {
			servers = {
				-- https://www.getfoundry.sh/config/editors#solidity-language-server
				forge_lsp = {
					cmd = { "forge", "lsp" },
					filetypes = { "solidity" },
					root_markers = { "foundry.toml" },
				},
			},
		},
	},
	{
		"nvim-treesitter/nvim-treesitter",
		opts = {
			ensure_installed = {
				"solidity"
			}
		}
	},
	{
		"stevearc/conform.nvim",
		opts = function(_, opts)
			opts.formatters_by_ft = opts.formatters_by_ft or {}
			opts.formatters_by_ft["solidity"] = { "forge_fmt" }
		end,
	},
}
