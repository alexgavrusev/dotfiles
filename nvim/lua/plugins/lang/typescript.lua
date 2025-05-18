vim.lsp.enable("ts_ls")
vim.lsp.enable("eslint")

return {
	{
		"nvim-treesitter/nvim-treesitter",
		opts = {
			ensure_installed = {
				"javascript",
				"typescript",
				"tsx",
			}
		}
	},
	{
		"williamboman/mason.nvim",
		opts = {
			ensure_installed = {
				"typescript-language-server",
				"eslint-lsp",
				"prettierd",
				"js-debug-adapter"
			}
		}
	},
	{
		"stevearc/conform.nvim",
		opts = function(_, opts)
			require("utils.conform").configure_prettier(opts, {
				"javascript",
				"javascriptreact",
				"typescript",
				"typescriptreact",
			})
		end,
	},
	{
		"mfussenegger/nvim-dap",
		opts = function()
			local vscode = require("dap.ext.vscode")
			vscode.json_decode = function(str)
				local json = require("plenary.json")
				return vim.json.decode(json.json_strip_comments(str))
			end

			local dap = require("dap")
			dap.adapters["pwa-node"] = {
				type = "server",
				host = "localhost",
				port = "${port}",
				executable = {
					command = "node",
					args = {
						vim.fn.expand("$MASON/packages/js-debug-adapter/js-debug/src/dapDebugServer.js"),
						"${port}",
					},
				},
			}

			local js_filetypes = { "typescript", "javascript", "typescriptreact", "javascriptreact" }

			local vscode = require("dap.ext.vscode")
			vscode.type_to_filetypes["node"] = js_filetypes
			vscode.type_to_filetypes["pwa-node"] = js_filetypes

			for _, language in ipairs(js_filetypes) do
				if not dap.configurations[language] then
					dap.configurations[language] = {
						{
							type = "pwa-node",
							request = "launch",
							name = "Launch file",
							program = "${file}",
							cwd = "${workspaceFolder}",
						},
						{
							type = "pwa-node",
							request = "attach",
							name = "Attach",
							processId = require("dap.utils").pick_process,
							cwd = "${workspaceFolder}",
						},
					}
				end
			end
		end
	}
}
