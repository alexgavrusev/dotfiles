vim.api.nvim_create_autocmd("FileType", {
	pattern = "markdown",
	callback = function()
		vim.opt_local.linebreak = true
	end,
})

return {
	{
		"nvim-treesitter/nvim-treesitter",
		opts = {
			ensure_installed = {
				"markdown",
				"markdown_inline"
			}
		}
	},
	{
		"stevearc/conform.nvim",
		opts = function(_, opts)
			require("utils.conform").configure_oxfmt(opts, {
				"markdown"
			})
		end,
	},
	{
		"MeanderingProgrammer/render-markdown.nvim",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"ice345/markdown-table-wrap.nvim",
		},
		opts = {
			enabled = false,
			heading = {
				icons = {},
			},
			code = {
				-- to get mermaid rendering with snacks.image working
				disable = { "mermaid" },
			},
			pipe_table = {
				-- using markdown-table-wrap.nvim while https://github.com/MeanderingProgrammer/render-markdown.nvim/issues/616 is open
				enabled = false,
			},
		},
		keys = {
			{
				"<leader>mp",
				function()
					local rm = require("render-markdown")
					local mtw = require("markdown-table-wrap")
					rm.toggle()
					if rm.get() then
						mtw.enable_auto_preview()
					else
						mtw.disable_auto_preview()
					end
				end,
				ft = "markdown",
				desc = "Toggle markdown preview",
			},
		},
	},
	{
		"ice345/markdown-table-wrap.nvim",
		opts = {
			-- start disabled to match render-markdown, so <leader>mp toggles both in sync
			auto_preview = false,
		},
		lazy = true
	},
}
