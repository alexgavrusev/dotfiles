return {
	"stevearc/conform.nvim",
	dependencies = {
		"williamboman/mason.nvim",
	},
	event = "VeryLazy",
	keys = require("config.keymaps").conform,
	-- NOTE: extended in lang configs
	opts = {
		default_format_opts = {
			lsp_format = "fallback",
		},
		format_on_save = function()
			if require("utils.lazy").has_plugin("mini.files") then
				-- Do not run conform when mini.files is open
				-- When it is opened, BufWritePre are emitted when files for which buffers exist get moved
				-- Attempting to run conform in those cases results in mini.files losing focus, and the synchronization process breaking
				local buf_ids = vim.api.nvim_list_bufs();
				for _, buf_id in ipairs(buf_ids) do
					local ft = vim.bo[buf_id].filetype;
					if ft == 'minifiles' or ft == 'minifiles-help' then return end
				end
			end

			return { timeout_ms = 500 }
		end
	},
}
