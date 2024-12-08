local M = {}

--- taken from https://github.com/stevearc/oil.nvim/blob/9a59256c8e88b29d2150e99b5960b2f111e51f75/lua/oil/lsp/workspace.lua#L16
---@param method string
---@return vim.lsp.Client[]
local function get_clients(method)
	if vim.fn.has("nvim-0.10") == 1 then
		return vim.lsp.get_clients({ method = method })
	else
		---@diagnostic disable-next-line: deprecated
		local clients = vim.lsp.get_active_clients()
		return vim.tbl_filter(function(client)
			return client.supports_method(method)
		end, clients)
	end
end

---@param request_method string
---@param notification_method string
---@param params table
local function file_operation_request_and_notify(request_method, notification_method, params)
	local a = require('plenary.async')

	-- NOTE(async): ts_ls is incredibly slow, and using request_sync with it also
	-- results in losing BufReadPost and BufEnter events for buffers added in apply_workspace_edit
	a.run(function()
		for _, client in ipairs(get_clients(request_method)) do
			local tx, rx = a.control.channel.oneshot()

			client.request(request_method, params, function(err, result, ctx)
				tx(result)
			end, 0)

			local result = rx()

			if result ~= nil then
				vim.lsp.util.apply_workspace_edit(result, client.offset_encoding)
			end
		end

		for _, client in ipairs(get_clients(notification_method)) do
			client.notify(notification_method, params)
		end
	end)
end

--- Lets LSP clients know that a file has been renamed
---@param from string
---@param to string
function M.on_rename_file(from, to)
	file_operation_request_and_notify(
		"workspace/willRenameFiles",
		"workspace/didRenameFiles",
		{
			files = {
				{
					oldUri = vim.uri_from_fname(from),
					newUri = vim.uri_from_fname(to),
				}
			}
		}
	)
end

--- Lets LSP clients know that a file has been created
---@param name string
function M.on_create_file(name)
	file_operation_request_and_notify(
		"workspace/willCreateFiles",
		"workspace/didCreateFiles",
		{
			files = {
				{
					uri = vim.uri_from_fname(name),
				}
			}
		}
	)
end

--- Lets LSP clients know that a file has been deleted
---@param name string
function M.on_delete_file(name)
	file_operation_request_and_notify(
		"workspace/willCreateFiles",
		"workspace/didCreateFiles",
		{
			files = {
				{
					uri = vim.uri_from_fname(name),
				}
			}
		}
	)
end

function M.default_capabilities()
	return {
		workspace = {
			fileOperations = {
				willRename = true,
				didRename = true,
				willCreate = true,
				didCreate = true,
				willDelete = true,
				didDelete = true,
			},
		},
	}
end

return M
