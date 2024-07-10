local M = {}

M.list_extend_uniq = function(dst, src)
	-- handle nil dst by falling back to empty list
	dst = dst or {}

	local uniq_src = {}

	for _, v in ipairs(src) do
		if not vim.tbl_contains(dst, v) then
			uniq_src[#uniq_src + 1] = v
		end
	end

	return vim.list_extend(dst, uniq_src)
end

return M
