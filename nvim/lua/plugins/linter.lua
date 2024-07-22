return {
	{
		"neovim/nvim-lspconfig",
		opts = {
			servers = {
				eslint = {
					filetypes = {
						'javascript',
						'javascriptreact',
						'typescript',
						'typescriptreact',
						'astro'
					},
				}
			}
		}
	},
}
