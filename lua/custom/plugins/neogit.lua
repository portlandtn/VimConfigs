return {
	"NeogitOrg/neogit",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"sindrets/diffview.nvim", -- Optional integration
	},
	keys = {
		{ "<leader>nui", ":Neogit<CR>", desc = "[G]it g[U][I] (Neogit)" },
	},
	config = function()
		require("neogit").setup({
			integrations = {
				diffview = true, -- Integrates with Diffview if you open commits or branches
			},
			signs = {
				section = { "", "" },
				item = { "", "" },
				hunk = { "", "" },
			},
		})
	end,
}
