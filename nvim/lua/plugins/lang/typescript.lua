return {
	{
		"neovim/nvim-lspconfig",
		opts = {
			servers = {
				eslint = function(default_config)
					return {
						root_dir = require("utils.lsp").marker_root_dir(
							".eslint-root",
							default_config.root_dir
						),

						before_init = function(params, config)
							if default_config.before_init then
								default_config.before_init(params, config)
							end

							config.settings.workingDirectory = { directory = config.root_dir }
						end,

						settings = {
							-- https://github.com/microsoft/vscode-eslint/issues/1545#issuecomment-3899606054
							runtime = "node",
							execArgv = {
								"--max-old-space-size=8192"
							}
						}
					}
				end,
				vtsls = function(default_config)
					return {
						root_dir = require("utils.lsp").marker_root_dir(
							".vtsls-root",
							default_config.root_dir
						),

						settings = {
							-- https://github.com/yioneko/vtsls?tab=readme-ov-file#bad-performance-of-completion
							vtsls = {
								enableMoveToFileCodeAction = true,
								autoUseWorkspaceTsdk = true,
								experimental = {
									completion = {
										enableServerSideFuzzyMatch = true,
									},
								},
							},
							typescript = {
								updateImportsOnFileMove = { enabled = "always" },
								preferences = {
									autoImportFileExcludePatterns = {
										-- ruins completion perf
										"aws-sdk"
									},
								},
								tsserver = {
									maxTsServerMemory = 8192
								}
							},
						},
					}
				end,
			},
		},
	},
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
				"vtsls",
				"eslint-lsp",
				"js-debug-adapter"
			}
		}
	},
	{
		"stevearc/conform.nvim",
		opts = function(_, opts)
			require("utils.conform").configure_oxfmt(opts, {
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

			vscode.type_to_filetypes["node"] = js_filetypes
			vscode.type_to_filetypes["pwa-node"] = js_filetypes

			local function pick_port()
				local co = coroutine.running()
				return coroutine.create(function()
					vim.ui.input({
						prompt = "Enter debug port: ",
						default = tostring(9229),
					}, function(input)
						local port_num = tonumber(input)
						coroutine.resume(co, port_num)
					end)
				end)
			end

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
							port = pick_port,
							restart = true,
						},
					}
				end
			end
		end
	}
}
