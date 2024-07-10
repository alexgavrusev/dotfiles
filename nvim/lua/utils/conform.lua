local M = {}

M.configure_prettier = function(opts, filetypes)
	local formatters_by_ft = {}

	for _, v in ipairs(filetypes) do
		formatters_by_ft[v] = { "prettierd" }
	end

	opts.formatters_by_ft = vim.tbl_extend("force", opts.formatters_by_ft or {}, formatters_by_ft)

	opts.formatters = {
		prettierd = {
			env = {
				PRETTIERD_LOCAL_PRETTIER_ONLY = 1
			}
		}
	}
end

return M
