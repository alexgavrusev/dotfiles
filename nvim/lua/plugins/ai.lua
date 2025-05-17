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
							tools = true
						},
						handlers = {
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
								default = "qwen3:14b",
							},
						},
					})
				end,
			},
			strategies = {
				chat = {
					adapter = "ollama",
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
