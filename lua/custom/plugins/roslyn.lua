return {
	{
		"seblyng/roslyn.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"williamboman/mason.nvim",
		},
		ft = { "cs" },
		config = function()
			require("roslyn").setup({
				dotnet_cmd = "dotnet",
				-- roslyn_version = "4.8.0-3.23475.3", -- Change to latest if needed
				on_attach = function(client, bufnr)
					local map = function(mode, lhs, rhs, desc)
						vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
					end
					map("n", "<leader>rn", vim.lsp.buf.rename, "Rename")
					map("n", "<leader>.", vim.lsp.buf.code_action, "Code Action")
					map("v", "<leader>rm", vim.lsp.buf.range_code_action, "Extract Method")
				end,
			})
		end,
	},
}
