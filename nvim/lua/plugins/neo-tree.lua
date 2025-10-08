return {
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			"nvim-tree/nvim-web-devicons", -- optional, but recommended
		},
		lazy = false, -- neo-tree will lazily load itself
		config = function()
			local tree = require("neo-tree")
			tree.setup({
				filesystem = {
					filtered_items = {
						visible = true, -- This is what you want: If you set this to `true`, all "hide" just mean "dimmed out"
						hide_dotfiles = false,
						hide_gitignored = true,
					},
				},
			})
			vim.keymap.set("n", "<C-n>", ":Neotree filesystem toggle left<CR>", { desc = "Telescope find files" })
		end,
	},
}
