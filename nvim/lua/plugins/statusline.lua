return {
	"nvim-lualine/lualine.nvim",
	dependencies = {
		"nvim-tree/nvim-web-devicons"
	},
	config = function()
		local lualine_b = {
			{
				"filename",
				path = 1
			}
		};
		local lualine_c = {
			"diagnostics"
		};
		local lualine_x = { "filetype" };
		local lualine_y = { "progress" };
		local lualine_z = { "location" };

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
