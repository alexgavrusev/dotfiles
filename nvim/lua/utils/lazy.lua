local M = {}

---@param name string
function M.has_plugin(name)
	return require("lazy.core.config").spec.plugins[name] ~= nil
end

return M
