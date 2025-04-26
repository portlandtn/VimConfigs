return {
	"nvim-telescope/telescope.nvim",
	keys = {
		{
			"<leader>tsf",
			function()
				require("telescope.builtin").find_files()
			end,
			desc = "[T]elescope [S]earch [F]iles",
		},
		{
			"<leader>tsg",
			function()
				require("telescope.builtin").live_grep()
			end,
			desc = "[T]elescope [S]earch by [G]rep",
		},
		{
			"<leader>tss",
			function()
				require("telescope.builtin").builtin()
			end,
			desc = "[T]elescope [S]elect Telescope",
		},
		{
			"<leader>tsh",
			function()
				require("telescope.builtin").help_tags()
			end,
			desc = "[T]elescope [S]earch [H]elp",
		},
		{
			"<leader>tsk",
			function()
				require("telescope.builtin").keymaps()
			end,
			desc = "[T]elescope [S]earch [K]eymaps",
		},
		{
			"<leader>tsw",
			function()
				require("telescope.builtin").grep_string()
			end,
			desc = "[T]elescope [S]earch current [W]ord",
		},
		{
			"<leader>tsd",
			function()
				require("telescope.builtin").diagnostics()
			end,
			desc = "[T]elescope [S]earch [D]iagnostics",
		},
		{
			"<leader>tsr",
			function()
				require("telescope.builtin").resume()
			end,
			desc = "[T]elescope [S]earch [R]esume",
		},
		{
			"<leader>ts.",
			function()
				require("telescope.builtin").oldfiles()
			end,
			desc = '[T]elescope [S]earch Recent Files ("." for repeat)',
		},
		{
			"<leader>ttb",
			function()
				require("telescope.builtin").buffers()
			end,
			desc = "[T]elescope [T]oggle [B]uffers",
		},

		-- Git-related Telescope builtins:
		{
			"<leader>tgc",
			function()
				require("telescope.builtin").git_commits()
			end,
			desc = "[T]elescope [G]it [C]ommits",
		},
		{
			"<leader>tgb",
			function()
				require("telescope.builtin").git_branches()
			end,
			desc = "[T]elescope [G]it [B]ranches",
		},
		{
			"<leader>tgs",
			function()
				require("telescope.builtin").git_status()
			end,
			desc = "[T]elescope [G]it [S]tatus",
		},
		{
			"<leader>tgS",
			function()
				require("telescope.builtin").git_stash()
			end,
			desc = "[T]elescope [G]it [S]tash",
		},
	},
	dependencies = {
		"nvim-lua/plenary.nvim",
		{
			"nvim-telescope/telescope-fzf-native.nvim",
			build = "make",
			cond = function()
				return vim.fn.executable("make") == 1
			end,
		},
		{ "nvim-telescope/telescope-ui-select.nvim" },
		{ "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
	},
	config = function()
		local telescope = require("telescope")
		local builtin = require("telescope.builtin")

		telescope.setup({
			extensions = {
				["ui-select"] = {
					require("telescope.themes").get_dropdown(),
				},
			},
		})

		-- Load Extensions
		pcall(telescope.load_extension, "fzf")
		pcall(telescope.load_extension, "ui-select")

		-- 🔥 Custom / wrapper mappings (these stay down here)
		vim.keymap.set(
			"n",
			"<leader>tht",
			require("telescope").extensions.harpoon.marks,
			{ desc = "[T]elescope [H]arpoon [T]elescope" }
		)

		vim.keymap.set("n", "<leader>tsgc", function()
			builtin.live_grep({
				additional_args = function()
					return { "--glob", "*.cs" }
				end,
			})
		end, { desc = "[T]elescope [S]earch [G]rep only .cs files" })

		vim.keymap.set("n", "<leader>t/", function()
			builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
				winblend = 10,
				previewer = false,
			}))
		end, { desc = "[T]elescope Fuzzy Search in Current Buffer" })

		vim.keymap.set("n", "<leader>ts/", function()
			builtin.live_grep({
				grep_open_files = true,
				prompt_title = "Live Grep in Open Files",
			})
		end, { desc = "[T]elescope [S]earch [/] in Open Files" })

		vim.keymap.set("n", "<leader>tsn", function()
			builtin.find_files({ cwd = vim.fn.stdpath("config") })
		end, { desc = "[T]elescope [S]earch [N]eovim config files" })

		-- Uncomment if needed:
		-- vim.keymap.set("n", "gr", builtin.lsp_references, { desc = "[G]oto [R]eferences" })
	end,
}
