return {
	{
		"akinsho/bufferline.nvim",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
			"catppuccin/nvim",
		},
		event = "LazyFile",
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
			close_command = function(n)
				require("bufdel").delete_buffer_expr(n)
			end
		},
		config = function(_, opts)
			local highlights = require("catppuccin.groups.integrations.bufferline").get()

			require("bufferline").setup({
				options = opts,
				highlights = highlights
			})

			-- fixes refresh delays when e.g. closing buffers
			-- inspired by https://github.com/LazyVim/LazyVim/blob/db8895b518278331fb73bbd81975cbe5012c8f71/lua/lazyvim/plugins/ui.lua#L86
			vim.api.nvim_create_autocmd({ "BufAdd", "BufDelete" }, {
				callback = function()
					vim.schedule(function()
						require("bufferline.ui").refresh()
					end)
				end,
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
