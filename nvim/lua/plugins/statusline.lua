return {
	{
		"echasnovski/mini-git",
		version = "*",
		lazy = true,
	},
	{
		"echasnovski/mini.statusline",
		version = "*",
		event = "VeryLazy",
		dependencies = {
			"echasnovski/mini.icons"
		},
		config = function()
			local statusline = require("mini.statusline")

			statusline.setup({
				content = {
					active = function()
						local mode, mode_hl = statusline.section_mode({ trunc_width = 50 })
						local git           = statusline.section_git({ trunc_width = 40 })
						local diagnostics   = statusline.section_diagnostics({ trunc_width = 75 })
						local lsp           = statusline.section_lsp({ trunc_width = 75, icon = "LSP" })
						local filename      = statusline.section_filename({ trunc_width = 140 })
						local fileinfo      = statusline.section_fileinfo({ trunc_width = 120 })
						local location      = statusline.section_location({ trunc_width = 75 })
						local search        = statusline.section_searchcount({ trunc_width = 75 })

						return statusline.combine_groups({
							{ hl = mode_hl,                  strings = { mode } },
							{ hl = 'MiniStatuslineDevinfo',  strings = { git, diagnostics } },
							{ hl = 'MiniStatuslineFilename', strings = { filename } },
							'%=', -- End left alignment
							{ hl = 'MiniStatuslineDevinfo',  strings = { lsp } },
							{ hl = 'MiniStatuslineFileinfo', strings = { fileinfo } },
							{ hl = mode_hl,                  strings = { search, location } },
						})
					end
				}
			})
		end
	},
}
