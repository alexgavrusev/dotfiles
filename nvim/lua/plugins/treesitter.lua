return {
	{
		"nvim-treesitter/nvim-treesitter",
		event = { "VeryLazy" },
		cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
		build = ":TSUpdate",
		opts_extend = { "ensure_installed" },
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
		},
		config = function(_, opts)
			opts.ensure_installed = require("utils.lists").dedup(opts.ensure_installed)

			vim.g.tso = opts

			require("nvim-treesitter.configs").setup(opts)
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
		},
		event = { "VeryLazy" },
		config = function()
			require("nvim-treesitter.configs").setup({
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
				}
			})
		end
	},
	{
		"windwp/nvim-ts-autotag",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
		},
		event = "InsertEnter",
		opts = {},
	},
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		opts = {}
	}
}
