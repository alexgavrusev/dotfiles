return {
	{
		"nvim-treesitter/nvim-treesitter",
		event = { "VeryLazy" },
		cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
		build = ":TSUpdate",
		opts_extend = { "ensure_installed" },
		opts = {
			-- NOTE: extended in lang configs
			ensure_installed = {
				"vimdoc",
			},

			auto_install = false,

			highlight = {
				enable = true,
			},
		},
		config = function(_, opts)
			opts.ensure_installed = require("utils.lists").dedup(opts.ensure_installed)

			local ts = require("nvim-treesitter");

			ts.setup(opts)

			local installed = require('nvim-treesitter.config').get_installed()

			local to_install = vim.iter(opts.ensure_installed)
				:filter(function(parser)
					return not vim.tbl_contains(installed, parser)
				end)
				:totable()

			ts.install(to_install)

			installed = vim.tbl_extend("force", installed, to_install)

			vim.api.nvim_create_autocmd("FileType", {
				group = vim.api.nvim_create_augroup("user-treesitter", { clear = true }),
				callback = function(ev)
					local lang = vim.treesitter.language.get_lang(ev.match)
					if not installed[lang] then
						return
					end

					pcall(vim.treesitter.start, ev.buf)

					vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
				end,
			})
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
		},
		event = { "VeryLazy" },
		config = function()
			require("nvim-treesitter-textobjects").setup({
				select = {
					-- Automatically jump forward to textobj, similar to targets.vim
					lookahead = true,
				},
			})

			local map_select_textobjects = function(mappings)
				local select = require("nvim-treesitter-textobjects.select")

				for keys, capture in pairs(mappings) do
					vim.keymap.set({ "x", "o" }, keys, function()
						select.select_textobject(capture, "textobjects")
					end, { desc = "Select textobject " .. capture })
				end
			end

			map_select_textobjects({
				["af"] = "@function.outer",
				["if"] = "@function.inner",
				["ac"] = "@class.outer",
				["ic"] = "@class.inner",
				["ab"] = "@block.outer",
				["ib"] = "@block.inner",
			})
		end
	},
}
