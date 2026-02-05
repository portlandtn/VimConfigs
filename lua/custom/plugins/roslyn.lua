return {
	{
		"seblyng/roslyn.nvim",
		ft = { "cs", "csharp" },
		config = function()
			require("roslyn").setup({
				on_attach = function(client, bufnr)
					client.server_capabilities.inlayHintProvider = false
				end,
			})
		end,
	},
}
