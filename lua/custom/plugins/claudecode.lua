return {
	"coder/claudecode.nvim",
	dependencies = {
		"folke/snacks.nvim",
	},
	opts = {
		terminal_cmd = vim.fn.expand("~/.claude/local/claude"),
	},
	config = true,
}
