return {
	{
		"nvim-treesitter/nvim-treesitter",
		opts = {
			ensure_installed = {
				"markdown",
				"markdown_inline"
			}
		}
	},
	{
		"epwalsh/obsidian.nvim",
		version = "*", -- recommended, use latest release instead of latest commit
		lazy = true,
		event = {
			"BufReadPre " .. vim.fn.expand "~" .. "/second-brain/**.md",
			"BufNewFile " .. vim.fn.expand "~" .. "/second-brain/**.md",
		},
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		opts = {
			workspaces = {
				{
					name = "Second Brain",
					path = "~/second-brain",
				},
			},
			ui = {
				enable = false
			}
		},
	}
}
