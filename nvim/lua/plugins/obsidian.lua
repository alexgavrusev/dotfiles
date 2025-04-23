return {
	{
		"epwalsh/obsidian.nvim",
		version = "*",
		event = {
			"BufReadPre " .. vim.fn.expand("~") .. "/second-brain/**.md",
			"BufNewFile " .. vim.fn.expand("~") .. "/second-brain/**.md",
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
			},
			picker = {
				name = "mini.pick",
			},
		}
	}
}
