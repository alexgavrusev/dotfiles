return {
	{
		"saghen/blink.cmp",
		event = "InsertEnter",
		dependencies = {
			"rafamadriz/friendly-snippets",
			"echasnovski/mini.icons",
		},
		version = "*",
		opts = {
			keymap = { preset = "default" },
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
				documentation = { window = { border = "rounded" } },
			}
		},
		opts_extend = { "sources.default" }
	}
}
