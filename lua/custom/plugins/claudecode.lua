return {
	"coder/claudecode.nvim",
	enabled = vim.fn.executable("claude") == 1,
	cmd = { "ClaudeCode", "ClaudeCodeStart", "ClaudeCodeStatus", "ClaudeCodeSend", "ClaudeCodeAdd" },
	dependencies = { "folke/snacks.nvim" },
	opts = { terminal_cmd = "claude" },
}
