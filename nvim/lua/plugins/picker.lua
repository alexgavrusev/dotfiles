-- approach from https://github.com/echasnovski/mini.nvim/issues/1291
local load_temp_rg = function(f)
	local rg_env = "RIPGREP_CONFIG_PATH"
	local cached_rg_config = vim.uv.os_getenv(rg_env) or ""
	vim.uv.os_setenv(rg_env, vim.fn.stdpath("config") .. "/config/.rg")
	f()
	vim.uv.os_setenv(rg_env, cached_rg_config)
end

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
		lazy = true
	},
	{
		"echasnovski/mini.pick",
		version = "*",
		opts = {},
		cmd = {
			"Pick"
		},
		keys = {
			{
				"<leader>fb",
				function()
					local pick = require("mini.pick")

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
				end,
				desc = "Buffers"
			},
			{
				"<leader>ff",
				function()
					load_temp_rg(function()
						require("mini.pick").builtin.files(
							{ tool = "rg" }
						)
					end)
				end,
				desc = "Find file"
			},
			{
				"<leader>fg",
				function()
					load_temp_rg(function()
						require("mini.pick").builtin.grep_live(
							{ tool = "rg" }
						)
					end)
				end,
				desc = "Find file"
			},
			{
				"<leader>fs",
				function()
					-- TODO: show with syntax highlight
					require("mini.extra").pickers.buf_lines(
						{ scope = "current" }
					)
				end,
				desc = "Current buffer lines"
			},
			{
				"<leader>fd",
				function()
					require("mini.extra").pickers.lsp(
						{ scope = "document_symbol" }
					)
				end,
				desc = "Document symbols"
			},
			{
				"<leader>fw",
				function()
					require("mini.extra").pickers.lsp(
						{ scope = "workspace_symbol" }
					)
				end,
				desc = "Workspace symbols"
			}

		}
	},
}
