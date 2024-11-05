return {
	{
		"williamboman/mason.nvim",
		build = ":MasonUpdate",
		cmd = {
			"Mason",
			"MasonUpdate",
			"MasonInstall",
			"MasonUninstall",
			"MasonUninstallAll",
			"MasonLog"
		},
		opts_extend = { "ensure_installed" },
		opts = {
			-- NOTE: extended in lang configs
			ensure_installed = {},
			ui = {
				border = "rounded"
			}
		},
		config = function(_, opts)
			opts.ensure_installed = require("utils.lists").dedup(opts.ensure_installed)

			require("mason").setup(opts)
		end
	}
}
