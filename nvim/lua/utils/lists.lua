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

M.dedup = function(list)
	local ret = {}
	local seen = {}
	for _, v in ipairs(list) do
		if not seen[v] then
			table.insert(ret, v)
			seen[v] = true
		end
	end
	return ret
end

return M
