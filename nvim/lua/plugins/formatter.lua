return {
	"stevearc/conform.nvim",
	dependencies = {
		"williamboman/mason.nvim",
	},
	event = "VeryLazy",
	keys = require("config.keymaps").conform,
	-- NOTE: extended in lang configs
	opts = {
		format_on_save = {
			timeout_ms = 500,
			lsp_format = "fallback",
		}
	},
}
