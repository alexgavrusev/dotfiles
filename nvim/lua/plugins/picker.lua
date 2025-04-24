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
			"echasnovski/mini.icons",
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
		},
		config = function(_, opts)
			local pick = require("mini.pick")
			pick.setup(opts)

			pick.registry.buffers = function()
				-- see https://github.com/echasnovski/mini.nvim/issues/525#issuecomment-1767795741
				local wipeout_cur = function()
					local bufnr = pick.get_picker_matches().current.bufnr

					local items = {}
					for _, item in ipairs(pick.get_picker_items()) do
						if bufnr ~= item.bufnr then
							table.insert(items, item)
						end
					end
					pick.set_picker_items(items)

					require("bufdel").delete_buffer_expr(bufnr, false)
				end

				local wipeout_others = function()
					local picker_items = pick.get_picker_items()
					local current = pick.get_picker_matches().current

					pick.set_picker_items({ current })

					for _, item in ipairs(picker_items) do
						if item.bufnr ~= current.bufnr then
							require("bufdel").delete_buffer_expr(item.bufnr, false)
						end
					end
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
				local prev_ignorecase = vim.opt.ignorecase
				local prev_smartcase = vim.opt.smartcase

				vim.opt.ignorecase = true
				vim.opt.smartcase = true

				pick.builtin.files({ tool = "rg" })

				vim.opt.ignorecase = prev_ignorecase
				vim.opt.smartcase = prev_smartcase
			end

			-- approach from https://github.com/echasnovski/mini.nvim/issues/1291
			local load_temp_rg = function(f)
				local rg_env = "RIPGREP_CONFIG_PATH"
				local cached_rg_config = vim.uv.os_getenv(rg_env) or ""
				vim.uv.os_setenv(rg_env, vim.fn.stdpath("config") .. "/config/.rg")
				f()
				vim.uv.os_setenv(rg_env, cached_rg_config)
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
		end
	},
}
