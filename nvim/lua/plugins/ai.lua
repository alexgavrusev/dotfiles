return {
	{
		"nvim-lua/plenary.nvim",
		lazy = true
	},
	{
		"olimorris/codecompanion.nvim",
		dependencies = {
			"nvim-treesitter",
			"mcphub.nvim",
		},
		event = "VeryLazy",
		opts = {
			opts = {
				log_level = "DEBUG", -- For development
			},
			adapters = {
				ollama_tools = function()
					return require("codecompanion.adapters").extend("openai_compatible", {
						schema = {
							model = {
								-- default = "hf.co/unsloth/Qwen3-8B-GGUF:UD-Q4_K_XL"
								-- default = "hf.co/unsloth/Qwen3-8B-GGUF:UD-Q4_K_XL"
								default = "devstral:24b"
							},
						}
					})
				end,
			},
			strategies = {
				chat = {
					adapter = "ollama_tools",
					slash_commands = {
						["buffer"] = {
							opts = {
								provider = "mini_pick",
							},
						},
						["file"] = {
							opts = {
								provider = "mini_pick",
							},
						},
						["help"] = {
							opts = {
								provider = "mini_pick",
							},
						},
						["symbols"] = {
							opts = {
								provider = "mini_pick",
							},
						},
					},
					variables = {
						buffer = nil,
						lsp = nil,
						viewport = nil
					}
				},
				inline = {
					adapter = "ollama_tools",

					variables = {
						buffer = nil,
						lsp = nil,
						viewport = nil
					}
				},
				cmd = {
					adapter = "ollama_tools",
				},
			},
			extensions = {
				mcphub = {
					callback = "mcphub.extensions.codecompanion",
					opts = {
						show_result_in_chat = true, -- Show mcp tool results in chat
						make_vars = true, -- Convert resources to #variables
						make_slash_commands = true, -- Add prompts as /slash commands
					}
				}
			}
		},
		-- config = function(_, opts)
		-- 	require("codecompanion").setup(opts)
		--
		-- 	-- remove variables and tools that have mcp alternatives
		-- 	local config = require("codecompanion.config")
		--
		-- 	config.strategies.chat.variables.buffer = nil
		-- 	config.strategies.chat.variables.lsp = nil
		-- 	config.strategies.chat.variables.viewport = nil
		--
		-- 	config.strategies.chat.tools.groups.full_stack_dev = nil
		-- 	config.strategies.chat.tools.cmd_runner = nil
		-- 	config.strategies.chat.tools.editor = nil
		-- 	config.strategies.chat.tools.files = nil
		--
		-- 	config.strategies.inline.variables.buffer = nil
		-- end
	},
	{
		"ravitemer/mcphub.nvim",
		build = "bundled_build.lua",
		lazy = true,
		opts = {
			use_bundled_binary = true,

			auto_toggle_mcp_servers = false,
		}
	}
}
