return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		"MunifTanjim/nui.nvim",
	},
	cmd = "Neotree",
	keys = {
		{ "<leader>e", ":Neotree toggle<CR>", desc = "Toggle N[E]o Tree" },
	},
	opts = {
		close_if_last_window = true, -- Closes Neo-tree if it's the last window open
		popup_border_style = "rounded",
		enable_git_status = true,
		enable_diagnostics = true,
		default_component_configs = {
			indent = {
				with_markers = true,
				indent_size = 2,
				padding = 1,
			},
			icon = {
				default = vim.g.have_nerd_font and "" or "*",
				folder_closed = vim.g.have_nerd_font and "" or "+",
				folder_open = vim.g.have_nerd_font and "" or "-",
				folder_empty = vim.g.have_nerd_font and "ﰊ" or "-",
			},
			git_status = {
				symbols = vim.g.have_nerd_font and {
					added = "✚",
					modified = "",
					deleted = "✖",
					renamed = "➜",
					untracked = "",
					ignored = "",
					unstaged = "",
					staged = "",
					conflict = "",
				} or {
					added = "+",
					modified = "~",
					deleted = "-",
					renamed = ">",
					untracked = "?",
					ignored = "i",
					unstaged = "U",
					staged = "S",
					conflict = "!",
				},
			},
		},
		filesystem = {
			filtered_items = {
				visible = true, -- shows filtered items but grayed out
				hide_dotfiles = false, -- you can leave this false if you still want to see dotfiles like .gitignore
				hide_gitignored = true, -- hides things like .gitignored files
				hide_by_name = {
					".DS_Store", -- this hides .DS_Store
					"thumbs.db", -- another common Windows junk file, optional
				},
				never_show = {
					-- If you don't even want the option to "show hidden," you can put it here instead
					-- ".DS_Store",
				},
			},
			follow_current_file = {
				enabled = true,
			},
		},
	},
}
