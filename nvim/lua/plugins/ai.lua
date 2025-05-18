return {
	{
		"nvim-lua/plenary.nvim",
		lazy = true
	},
	{
		"olimorris/codecompanion.nvim",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
		},
		event = "VeryLazy",
		opts = {
			adapters = {
				ollama = function()
					local openai = require("codecompanion.adapters.openai")

					return require("codecompanion.adapters").extend("ollama", {
						opts = {
							tools = true,
						},
						handlers = {
							form_tools = function(self, tools)
								return openai.handlers.form_tools(self, tools)
							end,
							tools = {
								format_tool_calls = function(self, tools)
									return openai.handlers.tools.format_tool_calls(self, tools)
								end,
								output_response = function(self, tool_call, output)
									return openai.handlers.tools.output_response(self, tool_call, output)
								end,
							},
						},
						schema = {
							model = {
								default = "qwen3:0.6b",
							},
							num_ctx = {
								default = 16384,
							},
						},
					})
				end,
			},
			strategies = {
				chat = {
					adapter = "ollama",
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

				},
				inline = {
					adapter = "ollama",
				},
				cmd = {
					adapter = "ollama",

				},
			},
		},
	},
}
