return {
	{
		"akinsho/bufferline.nvim",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
			"catppuccin",
		},
		event = { "BufReadPost", "BufNewFile" },
		keys = require("config.keymaps").bufferline,
		opts = {
			offsets = {
				{
					filetype = "CHADTree",
					text = "File Explorer",
					text_align = "left",
					padding = 1,
				}
			},
		},
		config = function(_, opts)
			local highlights = require("catppuccin.groups.integrations.bufferline").get()

			require("bufferline").setup({
				options = opts,
				highlights = highlights
			})
		end,
	},
	{
		"ojroques/nvim-bufdel",
		opts = {
			quit = false
		},
		cmd = { "BufDel", "BufDelAll", "BufDelOthers" },
		keys = require("config.keymaps").bufdel,
	}
}
