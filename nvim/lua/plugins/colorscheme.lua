return {
	"catppuccin/nvim",
	name = "catppuccin",
	priority = 1000,
	opts = {
		default_integrations = false,
		integrations = {
			treesitter = true,
			treesitter_context = true,
			mason = true,
			native_lsp = {
				enabled = true,
				virtual_text = {
					errors = { "italic" },
					hints = { "italic" },
					warnings = { "italic" },
					information = { "italic" },
					ok = { "italic" },
				},
				underlines = {
					errors = { "underline" },
					hints = { "underline" },
					warnings = { "underline" },
					information = { "underline" },
					ok = { "underline" },
				},
				inlay_hints = {
					background = true,
				},
			},
			blink_cmp = true,
			lsp_trouble = true,
			gitsigns = true,
			mini = {
				enabled = true,
			},
			markdown = true,
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

				Pmenu = { fg = "none", bg = "none" },                -- Popup menu: normal item.
				PmenuSel = { fg = C.text, bg = C.surface0, style = { "bold" } }, -- Popup menu: selected item.
				PmenuSbar = { bg = C.surface1 },                     -- Popup menu: scrollbar.
				PmenuThumb = { bg = C.overlay0 },                    -- Popup menu: Thumb of the scrollbar.

				BlinkCmpLabelMatch = { fg = C.blue },
				BlinkCmpMenuSelection = { fg = "none", bg = C.surface1 },
			}
		end,
	},
	config = function(_, opts)
		require("catppuccin").setup(opts)

		vim.cmd([[colorscheme catppuccin-macchiato]])
	end,
}
