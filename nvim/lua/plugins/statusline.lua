return {
	"nvim-lualine/lualine.nvim",
	dependencies = {
		"nvim-tree/nvim-web-devicons"
	},
	config = function()
		local lualine_b = { "branch", "diagnostics" };
		local lualine_c = {};
		local lualine_x = { "filetype" };
		local lualine_y = { "progress" };
		local lualine_z = { "location" };


		local trouble = require("trouble")
		local symbols = trouble.statusline({
			mode = "lsp_document_symbols",
			groups = {},
			title = false,
			filter = { range = true },
			format = "{kind_icon}{symbol.name:Normal} {hl:lualine_b_normal}",
			-- The following line is needed to fix the background color
			-- Set it to the lualine section you want to use
			hl_group = "lualine_c_normal",
			sep = ""
		})
		table.insert(lualine_c, {
			symbols.get,
			cond = symbols.has,
		})

		local opts = {
			sections = {
				lualine_a = { "mode" },
				lualine_b = lualine_b,
				lualine_c = lualine_c,
				lualine_x = lualine_x,
				lualine_y = lualine_y,
				lualine_z = lualine_z,
			},
			inactive_sections = {
				lualine_a = {},
				lualine_b = lualine_b,
				lualine_c = lualine_c,
				lualine_x = lualine_x,
				lualine_y = lualine_y,
				lualine_z = lualine_z,
			},
			extensions = {
				"chadtree",
				"trouble"
			},
			options = {
				theme = "catppuccin"
			}
		}

		require("lualine").setup(opts)
	end
}
