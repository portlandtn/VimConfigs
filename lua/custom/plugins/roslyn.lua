return {
	"seblyng/roslyn.nvim",
	ft = "cs",
	enabled = vim.fn.executable("dotnet") == 1,
	dependencies = { "neovim/nvim-lspconfig" },
	opts = {},
	config = function(_, opts)
		local command = vim.fn.has("win32") == 1 and "roslyn.cmd" or "roslyn"
		if vim.fn.executable(command) == 0 and vim.fn.executable("Microsoft.CodeAnalysis.LanguageServer") == 0 then
			vim.notify("C# language support needs the Roslyn server; see VimConfigs README.", vim.log.levels.WARN)
			return
		end
		vim.lsp.config("roslyn", {
			capabilities = require("blink.cmp").get_lsp_capabilities(),
			on_attach = function(client)
				client.server_capabilities.inlayHintProvider = false
			end,
		})
		require("roslyn").setup(opts)
	end,
}
