return {
	"lewis6991/gitsigns.nvim",
	opts = {
		signs = {
			add = { text = "▎" },
			change = { text = "▎" },
			delete = { text = "" },
			topdelete = { text = "" },
			changedelete = { text = "▎" },
		},
		current_line_blame = true,
		current_line_blame_opts = {
			delay = 500,
		},
		current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
		preview_config = {
			border = "rounded",
			style = "minimal",
			relative = "cursor",
			row = 0,
			col = 1,
		},
		attach_to_untracked = false,
		watch_gitdir = {
			interval = 1000,
			follow_files = true,
		},
		disable = function(buf)
			local max_file_lines = 20000
			local ok, lines = pcall(vim.api.nvim_buf_line_count, buf)
			return ok and lines > max_file_lines
		end,
		on_attach = function(bufnr)
			local gs = package.loaded.gitsigns
			local map = function(mode, lhs, rhs, desc)
				vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
			end

			-- Navigation
			map("n", "]c", function()
				if vim.wo.diff then
					return "]c"
				end
				vim.schedule(gs.next_hunk)
				return "<Ignore>"
			end, "Next Hunk")
			map("n", "[c", function()
				if vim.wo.diff then
					return "[c"
				end
				vim.schedule(gs.prev_hunk)
				return "<Ignore>"
			end, "Previous Hunk")

			-- Actions
			map("n", "<leader>gp", gs.preview_hunk, "Preview Git Hunk")
			map("n", "<leader>gb", gs.blame_line, "Blame Line")
			map("n", "<leader>gh", gs.toggle_current_line_blame, "Toggle Line Blame")
			map("n", "<leader>gs", gs.stage_hunk, "Stage Hunk")
			map("n", "<leader>gu", gs.undo_stage_hunk, "Undo Stage Hunk")
			map("n", "<leader>gr", gs.reset_hunk, "Reset Hunk")
			map("n", "<leader>gR", gs.reset_buffer, "Reset Buffer")
			map("n", "<leader>gS", gs.stage_buffer, "Stage Buffer")
		end,
	},
}
