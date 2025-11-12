return {
	{
		"saghen/blink.cmp",
		event = "InsertEnter",
		dependencies = {
			"rafamadriz/friendly-snippets",
		},
		version = "*",
		opts = {
			-- To get completion in Snacks.input
			enabled = function() return true end,
			keymap = {
				preset = "default",
				['<C-u>'] = { 'scroll_signature_up', 'fallback' },
				['<C-d>'] = { 'scroll_signature_down', 'fallback' },
			},
			completion = {
				accept = {
					auto_brackets = {
						enabled = false
					},
				},
				list = {
					selection = {
						preselect = false,
						auto_insert = false
					}
				},
				menu = {
					border = "rounded",
					draw = {
						components = {
							-- https://cmp.saghen.dev/recipes.html#mini-icons
							kind_icon = {
								text = function(ctx)
									local kind_icon, _, _ = require('mini.icons').get('lsp', ctx.kind)
									return kind_icon
								end,
								highlight = function(ctx)
									local _, hl, _ = require('mini.icons').get('lsp', ctx.kind)
									return hl
								end,
							},
							kind = {
								highlight = function(ctx)
									local _, hl, _ = require('mini.icons').get('lsp', ctx.kind)
									return hl
								end,
							},
						}
					}
				},
				documentation = {
					auto_show = true,
					window = { border = "rounded" }
				},
				trigger = {
					show_on_blocked_trigger_characters = function(ctx)
						-- https://github.com/saghen/blink.cmp/issues/2007 -- to get decorators auto import
						if vim.bo.filetype == 'typescript' then return { ' ', '\n', '\t', '@' } end

						return { ' ', '\n', '\t' }
					end,
				}
			},
			signature = {
				enabled = true,
				window = {
					show_documentation = true
				}
			},
		},
		opts_extend = { "sources.default" }
	}
}
