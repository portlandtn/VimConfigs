return {
	-- Main Treesitter plugin
	{
		"nvim-treesitter/nvim-treesitter",
		-- Preserve this configuration API until a separate main-branch migration.
		branch = "master",
		build = ":TSUpdate",
		main = "nvim-treesitter.configs",
		opts = function()
			local compiler = false
			for _, name in ipairs({ "cc", "gcc", "clang", "cl", "zig" }) do
				compiler = compiler or vim.fn.executable(name) == 1
			end
			return {
				ensure_installed = compiler and {
					"bash",
					"c",
					"c_sharp",
					"diff",
					"html",
					"lua",
					"luadoc",
					"markdown",
					"markdown_inline",
					"query",
					"vim",
					"vimdoc",
					"javascript",
				} or {},
				auto_install = false,
				highlight = {
					enable = true,
					additional_vim_regex_highlighting = {
						"ruby",
						"c_sharp",
						"javascript",
					},
				},
				indent = { enable = true, disable = { "ruby" } },
				textobjects = {
					select = {
						enable = true,
						lookahead = true,
						keymaps = {
							["af"] = "@function.outer",
							["if"] = "@function.inner",
							["ac"] = "@class.outer",
							["ic"] = "@class.inner",
						},
					},
					move = {
						enable = true,
						set_jumps = true,
						goto_next_start = {
							["]f"] = "@function.outer",
							["]c"] = "@class.outer",
						},
						goto_previous_start = {
							["[f"] = "@function.outer",
							["[c"] = "@class.outer",
						},
					},
				},
			}
		end,
	},

	-- Sticky context header
	{
		"nvim-treesitter/nvim-treesitter-context",
		opts = {
			enable = true,
			max_lines = 5,
			trim_scope = "outer",
		},
	},

	-- Text objects
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		branch = "master",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
	},
}
