return {
	"sindrets/diffview.nvim",
	dependencies = { "nvim-lua/plenary.nvim" },
	keys = {
		{ "<leader>dvo", ":DiffviewOpen<CR>", desc = "[D]iff[V]iew [O]pen" },
		{ "<leader>dvh", ":DiffviewFileHistory<CR>", desc = "[D]iff[V]iew [H]istory (Repo)" },
		{ "<leader>dvf", ":DiffviewFileHistory %<CR>", desc = "[D]iff[V]iew [F]ile History (Current)" },
		{ "<leader>dvc", ":DiffviewClose<CR>", desc = "[D]iff[V]iew [C]lose" },
	},
	config = function()
		require("diffview").setup({
			-- No need to touch Telescope here
		})
	end,
}
