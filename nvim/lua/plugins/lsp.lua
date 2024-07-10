return {
	"neovim/nvim-lspconfig",
	event = "VeryLazy",
	dependencies = {
		"mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		"hrsh7th/cmp-nvim-lsp",
	},
	config = function(_, opts)
		local ensure_installed = {}
		-- individial langs add opts
		for server in pairs(opts.servers) do
			ensure_installed[#ensure_installed + 1] = server
		end

		local capabilities = require("cmp_nvim_lsp").default_capabilities()

		local on_attach = function(_, bufnr)
			require("config.keymaps").lsp_buffer(bufnr)
		end

		-- inspired by https://github.com/LazyVim/LazyVim/blob/bb36f71b77d8e15788a5b62c82a1c9ec7b209e49/lua/lazyvim/plugins/lsp/init.lua#L177
		local setup = function(server)
			local server_opts = vim.tbl_deep_extend("force", {
				capabilities = vim.deepcopy(capabilities),
				on_attach = on_attach
			}, opts.servers[server] or {})

			require("lspconfig")[server].setup(server_opts)
		end


		local mason_lsp = require("mason-lspconfig")

		mason_lsp.setup({
			ensure_installed = ensure_installed,
			handlers = { setup }
		})


		vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
			vim.lsp.handlers.hover,
			{ border = "rounded" }
		)
		vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
			vim.lsp.handlers.signature_help,
			{ border = "rounded" }
		)

		require('lspconfig.ui.windows').default_options.border = "rounded"

		local diagnostics_config = {
			update_in_insert = true
		}

		vim.diagnostic.config(diagnostics_config)
	end
}
