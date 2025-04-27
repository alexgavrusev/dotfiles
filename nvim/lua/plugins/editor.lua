return {
	{
		"echasnovski/mini.files",
		dependencies = {
			"echasnovski/mini.icons"
		},
		version = "*",
		keys = {
			{
				"<leader>e",
				function()
					require("mini.files").open(vim.api.nvim_buf_get_name(0), true)
				end,
				desc = "Open explorer in directory of current file (mini.files)"
			},
			{
				"<leader>E",
				function()
					require("mini.files").open(vim.uv.cwd(), true)
				end,
				desc = "Open explorer in cwd (mini.files)",
			},
		},
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

			local map_split = function(buf_id, lhs, direction)
				local rhs = function()
					-- Make new window and set it as target
					local cur_target = MiniFiles.get_explorer_state().target_window
					local new_target = vim.api.nvim_win_call(cur_target, function()
						vim.cmd(direction .. ' split')
						return vim.api.nvim_get_current_win()
					end)

					MiniFiles.set_target_window(new_target)
					MiniFiles.go_in({ close_on_file = true })
				end

				-- Adding `desc` will result into `show_help` entries
				local desc = 'Split ' .. direction
				vim.keymap.set('n', lhs, rhs, { buffer = buf_id, desc = desc })
			end

			vim.api.nvim_create_autocmd('User', {
				pattern = 'MiniFilesBufferCreate',
				callback = function(args)
					local buf_id = args.data.buf_id
					-- Tweak keys to your liking
					map_split(buf_id, '<C-s>', 'belowright horizontal')
					map_split(buf_id, '<C-v>', 'belowright vertical')
					map_split(buf_id, '<C-t>', 'tab')
				end,
				group = mini_files_group
			})
		end
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
