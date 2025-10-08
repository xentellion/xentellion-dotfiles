return {
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "master",
		lazy = false,
		build = ":TSUpdate",
		config = function()
			local config = require("nvim-treesitter.configs")
			config.setup({
				ensure_installed = { "lua", "python", "markdown", "json", "yaml", "vim", "csv" },
				ignore_install = { "javascript" },
				sync_install = false,
				highlight = { enable = true },
				indent = { enable = true },
				auto_install = true,
				modules = {},
			})
		end,
	},
}
