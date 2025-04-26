return {
	"neovim/nvim-lspconfig",
	event = "VeryLazy",
	dependencies = {
		"williamboman/mason.nvim",
	},
	config = function()
		vim.lsp.config('*', {
			capabilities = vim.tbl_deep_extend(
				"force",
				vim.lsp.protocol.make_client_capabilities(),
				require("blink.cmp").get_lsp_capabilities({}, false),
				require("utils.lsp").default_capabilities()
			),
		})

		local lsp_group = vim.api.nvim_create_augroup('user-lsp-attach', { clear = true })

		vim.api.nvim_create_autocmd('LspAttach', {
			group = lsp_group,
			callback = function(event)
				local map = function(modes, lhs, rhs, opts)
					if type(opts) == "string" then
						local desc = opts;
						opts = { desc = desc }
					end

					vim.keymap.set(modes, lhs, rhs, vim.tbl_extend("keep", opts, { buffer = event.buf }))
				end

				-- Taken from https://github.com/Jlchong3/config.nvim/blob/60c96804ab201077d02eff9455950d2532fe46c3/lua/custom/lsp.lua#L139
				-- Also see https://github.com/echasnovski/mini.nvim/issues/978#issuecomment-2428497300
				local on_list = function(opts)
					local previous = vim.fn.getqflist()

					vim.fn.setqflist({}, " ", opts)
					if #opts.items == 1 then
						vim.cmd.cfirst()
					else
						require("mini.extra").pickers.list({ scope = "quickfix" }, { source = { name = opts.title } })
					end

					vim.fn.setqflist(previous, " ")
				end

				map("n", "grn", vim.lsp.buf.rename, '[R]e[n]ame')

				map({ "n", "x" }, "gra", vim.lsp.buf.code_action, '[G]oto Code [A]ction')

				map("n", "grr", function() vim.lsp.buf.references(nil, { on_list = on_list }) end, "[G]oto [R]eferences")

				map("n", "gri", function() vim.lsp.buf.implementation({ on_list = on_list }) end,
					"[G]oto [I]mplementation")

				map("n", "grd", function() vim.lsp.buf.definition({ on_list = on_list }) end, "[G]oto [D]efinition")

				map("n", "grD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

				map("n", "grt", function() vim.lsp.buf.type_definition({ on_list = on_list }) end,
					"[T]ype Definition")
			end
		})
	end
}
