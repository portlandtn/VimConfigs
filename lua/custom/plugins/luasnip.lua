return {
	{
		"L3MON4D3/LuaSnip",
		dependencies = {
			"rafamadriz/friendly-snippets", -- Optional, for pre-made snippets
		},
		config = function()
			require("luasnip.loaders.from_vscode").lazy_load() -- For friendly-snippets (optional)

			-- Load the repository's VS Code JSON snippets
			require("luasnip.loaders.from_vscode").lazy_load({
				paths = vim.fn.stdpath("config") .. "/lua/custom/snippets",
			})
		end,
	},
}
