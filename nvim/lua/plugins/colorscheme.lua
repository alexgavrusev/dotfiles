return {
	"catppuccin/nvim",
	name = "catppuccin",
	priority = 1000,
	opts = {
		integrations = {
			treesitter = true,
			treesitter_context = true,
			mason = true,
			native_lsp = {
				enabled = true
			},
			cmp = true,
			lsp_trouble = true,
			gitsigns = true,
			mini = {
				enabled = true,
			},
		},
		custom_highlights = function(C)
			return {
				-- yellow too similar to green
				GitSignsChange = { fg = C.peach },
				-- https://github.com/LunarVim/LunarVim/discussions/4418
				NormalFloat = { fg = "none", bg = "none" },
				FloatBorder = { fg = "none", bg = "none" },

				TreesitterContext = { bg = C.crust },
				-- style is underline by default
				TreesitterContextBottom = { style = {} },
				TreesitterContextLineNumber = { bg = C.crust },
				TreesitterContextSeparator = { bg = C.crust },
			}
		end,
	},
	config = function(_, opts)
		require("catppuccin").setup(opts)

		vim.cmd([[colorscheme catppuccin-macchiato]])
	end,
}
