return {
	"catppuccin/nvim",
	name = "catppuccin",
	priority = 1000,
	opts = {
		integrations = {
			telescope = {
				enabled = true
			},
			treesitter = true,
			mason = true,
			native_lsp = {
				enabled = true
			},
			cmp = true,
			lsp_trouble = true,
		},
		custom_highlights = function()
			return {
				-- https://github.com/LunarVim/LunarVim/discussions/4418
				NormalFloat = { fg = "none", bg = "none" },
				FloatBorder = { fg = "none", bg = "none" },
			}
		end,
	},
	config = function(_, opts)
		require("catppuccin").setup(opts)

		vim.cmd([[colorscheme catppuccin-macchiato]])
	end,
}
