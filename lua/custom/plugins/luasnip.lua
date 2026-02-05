return {
	{
		"L3MON4D3/LuaSnip",
		dependencies = {
			"rafamadriz/friendly-snippets", -- Optional, for pre-made snippets
		},
		config = function()
			require("luasnip.loaders.from_vscode").lazy_load() -- For friendly-snippets (optional)

			-- Load your custom Lua-based snippets
			require("luasnip.loaders.from_lua").load({
				paths = "~/.config/nvim/lua/custom/snippets",
			})
		end,
	},
}
