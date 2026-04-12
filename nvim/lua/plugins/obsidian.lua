return {
	{
		"obsidian-nvim/obsidian.nvim",
		event = {
			"BufReadPre " .. vim.fn.expand("~") .. "/second-brain/**.md",
			"BufNewFile " .. vim.fn.expand("~") .. "/second-brain/**.md",
		},
		opts = {
			legacy_commands = false,
			workspaces = {
				{
					name = "Second Brain",
					path = "~/second-brain",
				},
			},
			ui = {
				enable = false,
			},
			footer = {
				enabled = false,
			},
			picker = {
				name = "mini.pick",
			},
		},
	},
}
