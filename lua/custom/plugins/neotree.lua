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
				folder_closed = "",
				folder_open = "",
				folder_empty = "ﰊ",
			},
			git_status = {
				symbols = {
					added = "✚",
					modified = "",
					deleted = "✖",
					renamed = "➜",
					untracked = "",
					ignored = "",
					unstaged = "",
					staged = "",
					conflict = "",
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
