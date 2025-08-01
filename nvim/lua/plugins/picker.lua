return {
	{
		"ojroques/nvim-bufdel",
		lazy = true,
		opts = {
			quit = false
		},
	},
	{
		"echasnovski/mini.extra",
		version = "*",
		lazy = true,
		opts = {}
	},
	{
		"echasnovski/mini.pick",
		version = "*",
		dependencies = {
			"echasnovski/mini.extra",
			"echasnovski/mini.icons"
		},
		cmd = { "Pick" },
		keys = {
			{
				"<leader>fr",
				"<cmd>Pick resume<cr>",
				desc = "Resume latest picker"
			},
			{
				"<leader>ff",
				"<cmd>Pick files<cr>",
				desc = "Find file"
			},
			{
				"<leader>fg",
				"<cmd>Pick grep_live<cr>",
				desc = "Live grep"
			},
			{
				"<leader>fb",
				"<cmd>Pick buffers<cr>",
				desc = "Buffers"
			},
			{
				"<leader>fs",
				"<cmd>Pick current_buf_lines<cr>",
				desc = "Current buffer lines"
			},
			{
				"<leader>fd",
				"<cmd>Pick lsp scope='document_symbol'<cr>",
				desc = "Document symbols"
			},
			{
				"<leader>fw",
				"<cmd>Pick lsp scope='workspace_symbol'<cr>",
				desc = "Workspace symbols"
			},
			{
				"<leader>fq",
				"<cmd>Pick list scope='quickfix'<cr>",
				desc = "Quickfix list"
			},
			{
				"<leader>fx",
				"<cmd>Pick diagnostic<cr>",
				desc = "Diagnostics (all)"
			},
			{
				"<leader>fX",
				"<cmd>Pick diagnostic scope='current'<cr>",
				desc = "Diagnostics (current buffer)"
			},
			{
				"<leader>fk",
				"<cmd>Pick keymaps<cr>",
				desc = "Keymaps"
			}
		},
		init = function()
			-- Taken from https://github.com/luisdavim/dotfiles/blob/f832fb56c1daa71b7ea60c8aa37f32ba1b04c7c8/files/config/nvim/init.lua#L959
			vim.ui.select = function(items, opts, on_choice)
				local get_cursor_anchor = function() return vim.fn.screenrow() < 0.5 * vim.o.lines and "NW" or "SW" end
				local num_items = #items
				local max_height = math.floor(0.45 * vim.o.columns)
				local height = math.min(math.max(num_items, 1), max_height)
				local start_opts = {
					options = { content_from_bottom = get_cursor_anchor() == "SW" },
					window = {
						config = {
							relative = "cursor",
							anchor = get_cursor_anchor(),
							row = get_cursor_anchor() == "NW" and 1 or 0,
							col = 0,
							width = math.floor(0.45 * vim.o.columns),
							height = height,
						},
					},
				}
				return require("mini.pick").ui_select(items, opts, on_choice, start_opts)
			end
		end,
		opts = {
			window = {
				config = {
					border = "rounded",
				},
			},
		},
		config = function(_, opts)
			local pick = require("mini.pick")
			pick.setup(opts)

			-- approach from https://github.com/echasnovski/mini.nvim/issues/1291
			local load_temp_rg = function(f)
				local rg_env = "RIPGREP_CONFIG_PATH"
				local cached_rg_config = vim.uv.os_getenv(rg_env) or ""
				vim.uv.os_setenv(rg_env, vim.fn.stdpath("config") .. "/config/.rg")
				f()
				vim.uv.os_setenv(rg_env, cached_rg_config)
			end

			local mini_pick_group = vim.api.nvim_create_augroup("user-mini-pick", { clear = true })

			local prev_ignorecase = nil
			local prev_smartcase = nil

			vim.api.nvim_create_autocmd('User', {
				pattern = 'MiniPickStart',
				callback = function()
					prev_ignorecase = vim.opt.ignorecase
					prev_smartcase = vim.opt.smartcase

					vim.opt.ignorecase = true
					vim.opt.smartcase = true
				end,
				group = mini_pick_group
			})

			vim.api.nvim_create_autocmd('User', {
				pattern = 'MiniPickStop',
				callback = function()
					vim.opt.ignorecase = prev_ignorecase
					vim.opt.smartcase = prev_smartcase

					prev_ignorecase = nil
					prev_smartcase = nil
				end,
				group = mini_pick_group
			})

			pick.registry.buffers = function()
				-- see https://github.com/echasnovski/mini.nvim/issues/525#issuecomment-1767795741
				local wipeout_cur = function()
					local matches = pick.get_picker_matches()
					if matches == nil or matches.current == nil then
						return
					end

					local bufnr = matches.current.bufnr

					local items = {}
					for _, item in ipairs(pick.get_picker_items()) do
						if bufnr ~= item.bufnr then
							table.insert(items, item)
						end
					end
					pick.set_picker_items(items)

					require("bufdel").delete_buffer_expr(bufnr, false)
				end

				local buffer_mappings = {
					wipeout_cur = { char = "<C-d>", func = wipeout_cur },
					-- TODO: create mapping for wipeout_others
				}

				pick.builtin.buffers({}, {
					mappings = buffer_mappings
				})
			end

			pick.registry.files = function()
				load_temp_rg(function()
					pick.builtin.files({ tool = "rg" })
				end)
			end

			pick.registry.grep_live = function()
				load_temp_rg(function()
					pick.builtin.grep_live(
						{ tool = "rg" }
					)
				end)
			end

			-- Taken from https://github.com/echasnovski/mini.nvim/discussions/988#discussioncomment-10398788
			local ns_digit_prefix = vim.api.nvim_create_namespace("cur-buf-pick-show")
			local show_cur_buf_lines = function(buf_id, items, query, opts)
				if items == nil or #items == 0 then
					return
				end

				-- Show as usual
				pick.default_show(buf_id, items, query, opts)

				-- Move prefix line numbers into inline extmarks
				local lines = vim.api.nvim_buf_get_lines(buf_id, 0, -1, false)
				local digit_prefixes = {}
				for i, l in ipairs(lines) do
					local _, prefix_end, prefix = l:find("^(%s*%d+│)")
					if prefix_end ~= nil then
						digit_prefixes[i], lines[i] = prefix, l:sub(prefix_end + 1)
					end
				end

				vim.api.nvim_buf_set_lines(buf_id, 0, -1, false, lines)
				for i, pref in pairs(digit_prefixes) do
					local opts = { virt_text = { { pref, "MiniPickNormal" } }, virt_text_pos = "inline" }
					vim.api.nvim_buf_set_extmark(buf_id, ns_digit_prefix, i - 1, 0, opts)
				end

				-- Set highlighting based on the curent filetype
				local ft = vim.bo[items[1].bufnr].filetype
				local has_lang, lang = pcall(vim.treesitter.language.get_lang, ft)
				local has_ts, _ = pcall(vim.treesitter.start, buf_id, has_lang and lang or ft)
				if not has_ts and ft then vim.bo[buf_id].syntax = ft end
			end

			pick.registry.current_buf_lines = function()
				require("mini.extra").pickers.buf_lines(
					{
						scope = "current", preserve_order = true },
					{
						source = { show = show_cur_buf_lines }
					}
				)
			end

			-- Taken from https://github.com/echasnovski/mini.nvim/blob/c122e852517adaf7257688e435369c050da113b1/lua/mini/extra.lua ; `show` changed to include item code and source
			local ns_id = {
				pickers = vim.api.nvim_create_namespace('MiniExtraPickers'),
			}

			local pick_clear_namespace = function(buf_id, ns_id)
				pcall(
					vim.api.nvim_buf_clear_namespace, buf_id, ns_id, 0, -1
				)
			end

			local pick_highlight_line = function(buf_id, line, hl_group, priority)
				local opts = { end_row = line, end_col = 0, hl_mode = 'blend', hl_group = hl_group, priority = priority }
				vim.api.nvim_buf_set_extmark(buf_id, ns_id.pickers, line - 1, 0, opts)
			end

			local hl_groups_ref = {
				[vim.diagnostic.severity.ERROR] = 'DiagnosticFloatingError',
				[vim.diagnostic.severity.WARN] = 'DiagnosticFloatingWarn',
				[vim.diagnostic.severity.INFO] = 'DiagnosticFloatingInfo',
				[vim.diagnostic.severity.HINT] = 'DiagnosticFloatingHint',
			}

			local diagnostic_show = function(buf_id, items_to_show, query)
				local items = vim.deepcopy(items_to_show)

				for _, item in ipairs(items) do
					item.text = string.format('%s  [%s - %s]', item.text, item.code, item.source)
				end

				pick.default_show(buf_id, items, query)

				pick_clear_namespace(buf_id, ns_id.pickers)
				for i, item in ipairs(items_to_show) do
					pick_highlight_line(buf_id, i, hl_groups_ref[item.severity], 199)
				end
			end

			pick.registry.diagnostic = function(local_opts)
				require("mini.extra").pickers.diagnostic(
					local_opts,
					{ source = { show = diagnostic_show } }
				)
			end
		end
	},
}
