local M = {}

M.configure_eslint = function(opts, filetypes)
	local linters_by_ft = {}

	for _, v in ipairs(filetypes) do
		linters_by_ft[v] = { "eslint_d" }
	end

	vim.env.ESLINT_D_LOCAL_ESLINT_ONLY = "1"

	opts.linters_by_ft = vim.tbl_extend("force", opts.linters_by_ft or {}, linters_by_ft)
end

return M
