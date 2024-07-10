return {
	"hrsh7th/nvim-cmp",
	version = false,
	event = "InsertEnter",
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-vsnip",
		"hrsh7th/vim-vsnip",
	},
	config = function()
		local cmp = require("cmp")

		cmp.setup({
			snippet = {
				expand = function(args)
					vim.fn["vsnip#anonymous"](args.body)
				end,
			},
			window = {
				completion = cmp.config.window.bordered(),
				documentation = cmp.config.window.bordered(),
			},
			sources = cmp.config.sources(
				{
					{ name = 'nvim_lsp' },
					{ name = 'vsnip' }
				},
				{
					{ name = 'buffer' },
				}
			),
			mapping = {
				["<CR>"] = cmp.mapping.confirm({ select = false }),
				["<Tab>"] = cmp.mapping.select_next_item(),
				["<S-Tab>"] = cmp.mapping.select_prev_item(),
			}
		})
	end,
}
