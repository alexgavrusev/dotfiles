return {
	{
		"echasnovski/mini.files",
		keys = require("config.keymaps").mini_files,
		opts = {
			-- Don't use `h`/`l` for easier cursor navigation during text edit
			mappings = {
				go_in       = '',
				go_in_plus  = 'L',
				go_out      = '',
				go_out_plus = 'H',
			},
			windows = {
				preview = true,

				width_focus = 50,
				width_nofocus = 50,
				width_preview = 50,
			},
		},
		config = function(_, opts)
			require("mini.files").setup(opts)

			local mini_files_group = vim.api.nvim_create_augroup("user-mini-files", { clear = true })

			vim.api.nvim_create_autocmd('User', {
				pattern = 'MiniFilesWindowOpen',
				callback = function(args)
					local win_id = args.data.win_id

					local config = vim.api.nvim_win_get_config(win_id)
					config.border = "rounded"
					vim.api.nvim_win_set_config(win_id, config)
				end,
				group = mini_files_group
			})

			vim.api.nvim_create_autocmd('User', {
				pattern = 'MiniFilesWindowUpdate',
				callback = function(args)
					local win = vim.wo[args.data.win_id]
					win.number = true
					win.relativenumber = true
				end,
				group = mini_files_group
			})

			local lsp_utils = require("utils.lsp")

			vim.api.nvim_create_autocmd('User', {
				pattern = { 'MiniFilesActionRename', 'MiniFilesActionMove' },
				callback = function(args)
					lsp_utils.on_rename_file(args.data.from, args.data.to)
				end,
				group = mini_files_group
			})

			vim.api.nvim_create_autocmd('User', {
				pattern = 'MiniFilesActionCreate',
				callback = function(args)
					lsp_utils.on_create_file(args.data.to)
				end,
				group = mini_files_group
			})

			vim.api.nvim_create_autocmd('User', {
				pattern = 'MiniFilesActionDelete',
				callback = function(args)
					lsp_utils.on_delete_file(args.data.from)
				end,
				group = mini_files_group
			})
		end
	},
	{
		"nvim-lua/plenary.nvim",
		lazy = true
	},
	{
		"folke/trouble.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		cmd = "Trouble",
		keys = require("config.keymaps").trouble,
		opts = {},
	},
	{
		"nvim-treesitter/nvim-treesitter-context",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
		},
		event = "VeryLazy",
		opts = {
			separator = ' '
		}
	}
}
