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
			ui = {
				border = "rounded"
			}
		},
	},
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		dependencies = {
			"williamboman/mason.nvim",

		},
		cmd = {
			"MasonToolsInstall",
			"MasonToolsInstallSync",
			"MasonToolsUpdate",
			"MasonToolsUpdateSync",
			"MasonToolsClean"
		},
		build = ":MasonToolsInstall",
		config = function(_, opts)
			local tool_installer = require("mason-tool-installer")

			-- NOTE: extended in lang configs
			tool_installer.setup(opts)
		end,
	},
}
