local M = {}

M.current_file_fuzzy = function()
	require("telescope.builtin").grep_string({
		word_match = "-w",
		only_sort_text = true,
		search = "",
		search_dirs = {
			vim.fn.expand('%')
		},

		path_display = "hidden",
		disable_devicons = true,
		additional_args = {
			"--trim",
		}
	})
end

return M
