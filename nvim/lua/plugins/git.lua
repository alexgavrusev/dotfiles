return {
	{
		"lewis6991/gitsigns.nvim",
		event = "VeryLazy",
		opts = {
			signcolumn = false,
			numhl = true,
			current_line_blame = true,
			current_line_blame_opts = {
				delay = 300,
				use_focus = false,
			},
			current_line_blame_formatter = '<author>, <author_time:%x %X> - <summary> (<abbrev_sha>)',
		}
	},
}
