return {
	"neovim/nvim-lspconfig",
	event = "VeryLazy",
	dependencies = {
		"mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		-- "hrsh7th/cmp-nvim-lsp",
	},
	config = function(_, opts)
		local ensure_installed = {}
		-- individial langs add opts
		for server in pairs(opts.servers) do
			ensure_installed[#ensure_installed + 1] = server
		end

		local capabilities = vim.tbl_deep_extend(
			"force",
			{},
			vim.lsp.protocol.make_client_capabilities(),
			require("blink.cmp").get_lsp_capabilities(),
			require("utils.lsp").default_capabilities(),
			opts.capabilities or {}
		)

		local on_attach = function(_, bufnr)
			require("config.keymaps").lsp_buffer(bufnr)
		end

		-- inspired by https://github.com/LazyVim/LazyVim/blob/ec5981dfb1222c3bf246d9bcaa713d5cfa486fbd/lua/lazyvim/plugins/lsp/init.lua#L191
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
