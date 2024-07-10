return {
	"mfussenegger/nvim-lint",
	dependencies = {
		"WhoIsSethDaniel/mason-tool-installer.nvim",
	},
	event = "VeryLazy",
	config = function(_, opts)
		local lint = require("lint")

		-- NOTE: extended in lang configs
		lint.linters_by_ft = opts.linters_by_ft

		local group = vim.api.nvim_create_augroup("nvim-lint", {
			clear = true
		})

		vim.api.nvim_create_autocmd({
			"BufReadPost",
			"InsertLeave",
			"TextChanged",
			"BufWritePost",
		}, {
			group = group,
			callback = function()
				lint.try_lint()
			end,
		})

		-- TODO: remove this after https://github.com/mfussenegger/nvim-lint/pull/586 is merged
		local orig_eslint_d_parser = lint.linters.eslint_d.parser
		lint.linters.eslint_d.parser = function(output, bufnr)
			local result = orig_eslint_d_parser(output, bufnr)
			for _, d in ipairs(result) do
				if string.find(d.message, "No ESLint configuration found") then
					vim.notify_once(d.message, vim.log.levels.WARN)
					return {}
				end
			end
			return result
		end
	end,

}
