return {
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			"williamboman/mason.nvim",
			"igorlfs/nvim-dap-view",
		},
		keys = {
			{ "<leader>dc", function() require("dap").continue() end,                                             desc = "[D]ebug Run/[C]ontinue (dap)" },
			{ "<leader>dt", function() require("dap").terminate() end,                                            desc = "[D]ebug [T]erminate (dap)" },
			{ "<leader>dD", function() require("dap").disconnect() end,                                           desc = "[D]ebug [D]isconnect (dap)" },

			{ "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, desc = "[D]ebug [B]reakpoint [C]ondition (dap)" },
			{ "<leader>db", function() require("dap").toggle_breakpoint() end,                                    desc = "[D]ebug Toggle [B]reakpoint (dap)" },
			{ "<leader>de", function() require("dap").set_exception_breakpoints() end,                            desc = "[D]ebug Set Breakpoints on [E]xception (dap)" },

			{ "<leader>dO", function() require("dap").step_over() end,                                            desc = "[D]ebug Step [O]ver (dap)" },
			{ "<leader>di", function() require("dap").step_into() end,                                            desc = "[D]ebug Step [I]nto (dap)" },
			{ "<leader>do", function() require("dap").step_out() end,                                             desc = "[D]ebug Step [O]ut (dap)" },
			{ "<leader>dC", function() require("dap").run_to_cursor() end,                                        desc = "[D]ebug Run to [C]ursor (dap)" },

			{ "<leader>dk", function() require("dap").up() end,                                                   desc = "[D]ebug Stacktrace [U]p (dap)" },
			{ "<leader>dj", function() require("dap").down() end,                                                 desc = "[D]ebug Stacktrace [D]own (dap)" },

			{ "<leader>dw", function() require("dap.ui.widgets").hover("<cexpr>", { border = "rounded" }) end,    desc = "[D]ebug [W]idgets (dap)" },

			{
				"<leader>ds",
				function()
					local w = require("dap.ui.widgets")
					w.cursor_float(w.sessions, { border = "rounded" }).open()
				end,
				desc = "[D]ebug [S]essions (dap)"
			},
		},
		config = function()
			-- https://github.com/mfussenegger/nvim-dap/issues/415#issuecomment-2230986168
			vim.api.nvim_create_autocmd("FileType", {
				pattern = "dap-float",
				callback = function()
					vim.api.nvim_buf_set_keymap(0, "n", "q", "<cmd>close!<CR>", { noremap = true, silent = true })
				end
			})

			for name, sign in pairs({
				Stopped             = { "󰁕 ", "DiagnosticWarn", "DapStoppedLine" },
				Breakpoint          = " ",
				BreakpointCondition = " ",
				BreakpointRejected  = { " ", "DiagnosticError" },
				LogPoint            = ".>",
			}) do
				sign = type(sign) == "table" and sign or { sign }
				vim.fn.sign_define(
					"Dap" .. name,
					{ text = sign[1], texthl = sign[2] or "DiagnosticInfo", linehl = sign[3], numhl = sign[3] }
				)
			end
		end,
	},
	{
		"igorlfs/nvim-dap-view",
		keys = {
			{ "<leader>du", function() require("dap-view").toggle({ hide_terminal = true }) end, desc = "[D]ebug [U]I (dap-ui)" }
		},
		opts = {
			winbar = {
				show = true,
				sections = { "watches", "scopes", "exceptions", "breakpoints", "threads", "repl", "console" },
			}

		},
	},
}
