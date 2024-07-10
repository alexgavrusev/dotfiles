return {
	{
		"nvim-treesitter/nvim-treesitter",
		dependencies = {
			"nvim-treesitter/nvim-treesitter-textobjects"
		},
		event = { "BufReadPost", "BufNewFile" },
		cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
		build = ":TSUpdate",
		opts = {
			-- NOTE: extended in lang configs
			ensure_installed = {
				"vimdoc",
			},

			-- Automatically install missing parsers when entering buffer
			auto_install = true,

			highlight = {
				enable = true,
			},

			textobjects = {
				select = {
					enable = true,

					-- Automatically jump forward to textobj, similar to targets.vim
					lookahead = true,

					keymaps = {
						["af"] = { query = "@function.outer", desc = "Select outer function" },
						["if"] = { query = "@function.inner", desc = "Select inner function" },
						["ac"] = { query = "@class.outer", desc = "Select outer class" },
						["ic"] = { query = "@class.inner", desc = "Select inner class" },
						["ab"] = { query = "@block.outer", desc = "Select outer block" },
						["ib"] = { query = "@block.inner", desc = "Select inner block" },
					},
				},
			},

		},
		config = function(_, opts)
			require("nvim-treesitter.configs").setup(opts)
		end,
	},
	{
		"windwp/nvim-ts-autotag",
		event = "InsertEnter",
		opts = {},
	},
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		opts = {}
	}
}
