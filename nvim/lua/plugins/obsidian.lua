return {
	{
		"nvim-treesitter/nvim-treesitter",
		opts = function(_, opts)
			require("utils.extend-ensure-installed")(opts, {
				"markdown",
				"markdown_inline"
			})
		end
	},
	{
		"epwalsh/obsidian.nvim",
		version = "*", -- recommended, use latest release instead of latest commit
		lazy = true,
		event = {
			"BufReadPre " .. vim.fn.expand "~" .. "/Second\\ Brain/**.md",
			"BufNewFile " .. vim.fn.expand "~" .. "/Second\\ Brain/**.md",
		},
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		opts = {
			workspaces = {
				{
					name = "Second Brain",
					path = "~/Second Brain",
				},
			},
			ui = {
				enable = false
			}
		},
	}
}
