return {
	{
		"neovim/nvim-lspconfig",
		opts = {
			servers = {
				clangd = function(default_config)
					return {
						cmd = {
							"clangd",
							"--background-index",
							"--clang-tidy",
							"--header-insertion=iwyu",
							"--completion-style=detailed",
							"--function-arg-placeholders",
							"--fallback-style=llvm",
						},
						root_markers = vim.tbl_filter(function(marker)
							return marker ~= ".git"
						end, default_config.root_markers),
					}
				end,
			},
		},
	},
	{
		"nvim-treesitter/nvim-treesitter",
		opts = {
			ensure_installed = {
				"cpp",
			},
		},
	},
	{
		"williamboman/mason.nvim",
		opts = {
			ensure_installed = {
				"clangd",
			},
		},
	},
}
