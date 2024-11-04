return {
	{
		"hrsh7th/nvim-cmp",
		version = false,
		event = "InsertEnter",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"garymjr/nvim-snippets",
		},
		config = function()
			local cmp = require("cmp")

			cmp.setup({
				snippet = {
					expand = function(args)
						vim.snippet.expand(args.body)
					end,
				},
				window = {
					completion = cmp.config.window.bordered(),
					documentation = cmp.config.window.bordered(),
				},
				sources = cmp.config.sources(
					{
						{ name = 'nvim_lsp' },
						{ name = 'snippets' },
					},
					{
						{ name = 'buffer' },
					}
				),
				-- inspired by https://github.com/hrsh7th/nvim-cmp/wiki/Example-mappings - Super-Tab like mapping and Safely select entries with <CR>
				mapping = {
					["<CR>"] = cmp.mapping({
						i = function(fallback)
							if not cmp.visible() then
								fallback()
							elseif cmp.get_active_entry() then
								cmp.confirm({ select = false })
							else
								cmp.abort()
							end
						end,
						s = cmp.mapping.confirm({ select = false }),
					}),

					["<Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
						elseif vim.snippet.active({ direction = 1 }) then
							vim.schedule(function()
								vim.snippet.jump(1)
							end)
						else
							fallback()
						end
					end, { "i", "s" }),

					["<S-Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
						elseif vim.snippet.active({ direction = -1 }) then
							vim.schedule(function()
								vim.snippet.jump(-1)
							end)
						else
							fallback()
						end
					end, { "i", "s" }),
				}
			})
		end,
	},
	{
		"garymjr/nvim-snippets",
		lazy = true,
		opts = {
			friendly_snippets = true,
		},
		dependencies = {
			"rafamadriz/friendly-snippets"
		},
	}
}
