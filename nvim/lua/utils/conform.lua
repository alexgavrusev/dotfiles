local M = {}

M.configure_prettier = function(opts, filetypes)
	local formatters_by_ft = {}

	for _, v in ipairs(filetypes) do
		formatters_by_ft[v] = { "prettier" }
	end

	opts.formatters_by_ft = vim.tbl_extend("force", opts.formatters_by_ft or {}, formatters_by_ft)
end

M.configure_oxfmt = function(opts, filetypes)
	local formatters_by_ft = {}

	for _, v in ipairs(filetypes) do
		formatters_by_ft[v] = { "oxfmt", "prettier", stop_after_first = true }
	end

	opts.formatters_by_ft = vim.tbl_extend("force", opts.formatters_by_ft or {}, formatters_by_ft)
end

return M
