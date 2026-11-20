return {
	{
		"neovim/nvim-lspconfig",
		opts = {
			servers = {
				clangd = {
					cmd = {
						"clangd",
						"--background-index",
						"--clang-tidy",
						"--completion-style=detailed",
						"--header-insertion=iwyu",
						-- https://docs.platformio.org/en/latest/integration/ide/neovim.html#clangd
						"--query-driver=" .. vim.fn.expand("~") .. "/.platformio/packages/toolchain-*/bin/*",
					},
					root_markers = {
						"platformio.ini",
						-- default, without .git
						{
							".clangd",
							".clang-tidy",
							".clang-format",
							"compile_commands.json",
							"compile_flags.txt",
							"configure.ac",
						},
					},
				},
			},
		},
	},
	{
		"nvim-treesitter/nvim-treesitter",
		opts = {
			ensure_installed = {
				"c",
				"cpp",
			},
		},
	},
	{
		"williamboman/mason.nvim",
		opts = {
			ensure_installed = {
				"clangd",
				"clang-format",
			},
		},
	},
	{
		"stevearc/conform.nvim",
		opts = function(_, opts)
			opts.formatters_by_ft = opts.formatters_by_ft or {}
			for _, filetype in ipairs({ "c", "cpp" }) do
				opts.formatters_by_ft[filetype] = { "clang_format" }
			end
		end,
	},
}
