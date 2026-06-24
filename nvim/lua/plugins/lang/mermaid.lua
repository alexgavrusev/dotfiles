return {
	{
		"williamboman/mason.nvim",
		opts = {
			ensure_installed = {
				"mmdc"
			}
		}
	},
	{
		"folke/snacks.nvim",
		opts = {
			image = {
				enabled = true,
				doc = {
					max_width = 120,
					max_height = 80,
				},
				convert = {
					mermaid = { "-i", "{src}", "-o", "{file}", "-b", "transparent", "-t", "dark", "-s", "2" },
				},
			},
		},
	}
}
