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

		local transform_mod = require('telescope.actions.mt').transform_mod

		local custom_actions = transform_mod({
			open_with_trouble = function(prompt_bufnr)
				local opts = {
					focus = true
				}

				require("trouble.sources.telescope").open(prompt_bufnr, opts)
			end
		})

		local opts = {
			defaults = {
				mappings = {
					i = { ["<c-t>"] = custom_actions.open_with_trouble },
					n = { ["<c-t>"] = custom_actions.open_with_trouble },
				},
			},

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
