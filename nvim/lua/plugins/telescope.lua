return {
	"nvim-telescope/telescope.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" }
	},
	cmd = "Telescope",
	keys = require("config.keymaps").telescope,
	config = function()
		local telescope = require("telescope")
		local telescopeConfig = require("telescope.config")

		-- Clone the default Telescope configuration
		local vimgrep_arguments = { unpack(telescopeConfig.values.vimgrep_arguments) }

		-- `hidden = true` will still show the inside of `.git/` as it's not `.gitignore`d.
		table.insert(vimgrep_arguments, "--hidden")
		table.insert(vimgrep_arguments, "--glob")
		table.insert(vimgrep_arguments, "!**/.git/*")

		local opts = {
			pickers = {
				find_files = {
					find_command = { "rg", "--files", "--color", "never", "--hidden", "--glob", "!**/.git/*" },
				},
				live_grep = {
					vimgrep_arguments = vimgrep_arguments
				}
			}
		}

		telescope.setup(opts)

		telescope.load_extension("fzf")
	end,
}
