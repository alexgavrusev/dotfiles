local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

local opts = {
	ui = {
		border = "rounded",
		backdrop = 100,
	}
}

require("lazy").setup({
	{ import = "plugins" },
	-- the globbing is not recursive, plugins in subdirs have to be included as such
	{ import = "plugins.lang" }
}, opts)
