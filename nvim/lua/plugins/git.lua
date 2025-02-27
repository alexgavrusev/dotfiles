return {
	{
		"lewis6991/gitsigns.nvim",
		event = "VeryLazy",
		opts = {
			signcolumn                   = false, -- Toggle with `:Gitsigns toggle_signs`
			numhl                        = true, -- Toggle with `:Gitsigns toggle_numhl`
			linehl                       = false, -- Toggle with `:Gitsigns toggle_linehl`
			word_diff                    = false, -- Toggle with `:Gitsigns toggle_word_diff`
			current_line_blame           = true, -- Toggle with `:Gitsigns toggle_current_line_blame`
			current_line_blame_opts      = {
				delay = 300,
				use_focus = false,
				virt_text = true,
				virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
				virt_text_priority = 100,
				ignore_whitespace = false,
			},
			current_line_blame_formatter = '<author>, <author_time:%x %X> - <summary> (<abbrev_sha>)',
			max_file_length              = 40000, -- Disable if file is longer than this (in lines)
		}
	},
}
