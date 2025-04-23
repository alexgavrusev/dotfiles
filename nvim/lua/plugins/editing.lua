return {
	{
		"windwp/nvim-ts-autotag",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
		},
		event = "InsertEnter",
		opts = {},
	},
	{
		"echasnovski/mini.pairs",
		version = "*",
		event = "InsertEnter",
		opts = {}
	},
	{
		"numToStr/Comment.nvim",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"JoosepAlviste/nvim-ts-context-commentstring",
		},
		event = "VeryLazy",
		config = function()
			require("Comment").setup({
				---Function to call before (un)comment
				---nvim-ts-context-commentstring is used to add support for tsx/jsx
				pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
			})
		end,
	}

}
