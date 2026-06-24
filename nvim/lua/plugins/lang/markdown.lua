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
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		opts = {
			enabled = false,
			heading = {
				icons = {},
			},
			code = {
				-- to get mermaid rendering with snacks.image working
				disable = { "mermaid" },
			},
		},
		keys = {
			{
				"<leader>mp",
				"<cmd>RenderMarkdown toggle<cr>",
				ft = "markdown",
				desc = "Toggle markdown preview",
			},
		},
	}
}
