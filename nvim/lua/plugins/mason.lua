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
		opts = {
			-- NOTE: extended in lang configs
			ensure_installed = {},
			ui = {
				border = "rounded"
			}
		},
	}
}
