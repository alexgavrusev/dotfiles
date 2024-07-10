return {
	{
		"ms-jpq/chadtree",
		branch = "chad",
		build = "python3 -m chadtree deps",
		cmd = { "CHADopen", "CHADhelp" },
		keys = require("config.keymaps").chadtree,
	},
	{
		"folke/trouble.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		cmd = "Trouble",
		keys = require("config.keymaps").trouble,
		opts = {},
	},
}
