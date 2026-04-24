vim.lsp.enable("eslint")
vim.lsp.enable("vtsls")

local eslint_config_files = {
	'.eslintrc',
	'.eslintrc.js',
	'.eslintrc.cjs',
	'.eslintrc.yaml',
	'.eslintrc.yml',
	'.eslintrc.json',
	'eslint.config.js',
	'eslint.config.mjs',
	'eslint.config.cjs',
	'eslint.config.ts',
	'eslint.config.mts',
	'eslint.config.cts',
}

vim.lsp.config('eslint', {
	root_dir = function(bufnr, on_dir)
		local marker_dir = vim.fs.root(bufnr, ".eslint-root")
		if marker_dir then
			on_dir(marker_dir)
			return
		end

		-- The project root is where the LSP can be started from
		-- As stated in the documentation above, this LSP supports monorepos and simple projects.
		-- We select then from the project root, which is identified by the presence of a package
		-- manager lock file.
		local root_markers = { 'package-lock.json', 'yarn.lock', 'pnpm-lock.yaml', 'bun.lockb', 'bun.lock' }
		-- Give the root markers equal priority by wrapping them in a table
		root_markers = vim.fn.has('nvim-0.11.3') == 1 and { root_markers, { '.git' } }
			or vim.list_extend(root_markers, { '.git' })

		-- exclude deno
		if vim.fs.root(bufnr, { 'deno.json', 'deno.jsonc', 'deno.lock' }) then
			return
		end

		-- We fallback to the current working directory if no project root is found
		local project_root = vim.fs.root(bufnr, root_markers) or vim.fn.getcwd()

		-- We know that the buffer is using ESLint if it has a config file
		-- in its directory tree.
		--
		-- Eslint used to support package.json files as config files, but it doesn't anymore.
		-- We keep this for backward compatibility.
		local filename = vim.api.nvim_buf_get_name(bufnr)
		local eslint_config_files_with_package_json =
			require("lspconfig.util").insert_package_json(eslint_config_files, 'eslintConfig', filename)
		local is_buffer_using_eslint = vim.fs.find(eslint_config_files_with_package_json, {
			path = filename,
			type = 'file',
			limit = 1,
			upward = true,
			stop = vim.fs.dirname(project_root),
		})[1]
		if not is_buffer_using_eslint then
			return
		end

		on_dir(project_root)
	end,

	before_init = function(_, config)
		config.settings.workingDirectory = { directory = config.root_dir }
	end,

	settings = {
		-- https://github.com/microsoft/vscode-eslint/issues/1545#issuecomment-3899606054
		runtime = "node",
		execArgv = {
			"--max-old-space-size=8192"
		}
	}
})

vim.lsp.config("vtsls", {
	root_dir = function(bufnr, on_dir)
		local marker_dir = vim.fs.root(bufnr, ".vtsls-root")
		if marker_dir then
			on_dir(marker_dir)
			return
		end

		-- The project root is where the LSP can be started from
		-- As stated in the documentation above, this LSP supports monorepos and simple projects.
		-- We select then from the project root, which is identified by the presence of a package
		-- manager lock file.
		local root_markers = { 'package-lock.json', 'yarn.lock', 'pnpm-lock.yaml', 'bun.lockb', 'bun.lock' }
		-- Give the root markers equal priority by wrapping them in a table
		root_markers = vim.fn.has('nvim-0.11.3') == 1 and { root_markers, { '.git' } }
			or vim.list_extend(root_markers, { '.git' })
		-- exclude deno
		local deno_root = vim.fs.root(bufnr, { 'deno.json', 'deno.jsonc' })
		local deno_lock_root = vim.fs.root(bufnr, { 'deno.lock' })
		local project_root = vim.fs.root(bufnr, root_markers)
		if deno_lock_root and (not project_root or #deno_lock_root > #project_root) then
			-- deno lock is closer than package manager lock, abort
			return
		end
		if deno_root and (not project_root or #deno_root >= #project_root) then
			-- deno config is closer than or equal to package manager lock, abort
			return
		end
		-- project is standard TS, not deno
		-- We fallback to the current working directory if no project root is found
		on_dir(project_root or vim.fn.getcwd())
	end,

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
})

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
