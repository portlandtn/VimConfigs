return {
	"nvim-telescope/telescope.nvim",
	keys = {
		{
			"<leader>sf",
			function()
				require("telescope.builtin").find_files()
			end,
			desc = "[S]earch [F]iles",
		},
		{
			"<leader>sg",
			function()
				require("telescope.builtin").live_grep()
			end,
			desc = "[S]earch by [G]rep",
		},
		{
			"<leader>ss",
			function()
				require("telescope.builtin").builtin()
			end,
			desc = "[S]elect Telescope",
		},
		{
			"<leader>sh",
			function()
				require("telescope.builtin").help_tags()
			end,
			desc = "[S]earch [H]elp",
		},
		{
			"<leader>sk",
			function()
				require("telescope.builtin").keymaps()
			end,
			desc = "[S]earch [K]eymaps",
		},
		{
			"<leader>sw",
			function()
				require("telescope.builtin").grep_string()
			end,
			desc = "[S]earch current [W]ord",
		},
		{
			"<leader>sd",
			function()
				require("telescope.builtin").diagnostics()
			end,
			desc = "[S]earch [D]iagnostics",
		},
		{
			"<leader>sr",
			function()
				require("telescope.builtin").resume()
			end,
			desc = "[S]earch [R]esume",
		},
		{
			"<leader>s.",
			function()
				require("telescope.builtin").oldfiles()
			end,
			desc = '[S]earch Recent Files ("." for repeat)',
		},
		{
			"<leader>tb",
			function()
				require("telescope.builtin").buffers()
			end,
			desc = "[T]oggle [B]uffers",
		},

		-- Git-related Telescope builtins:
		{
			"<leader>gc",
			function()
				require("telescope.builtin").git_commits()
			end,
			desc = "[G]it [C]ommits",
		},
		{
			"<leader>gb",
			function()
				require("telescope.builtin").git_branches()
			end,
			desc = "[G]it [B]ranches",
		},
		{
			"<leader>gs",
			function()
				require("telescope.builtin").git_status()
			end,
			desc = "[G]it [S]tatus",
		},
		{
			"<leader>gS",
			function()
				require("telescope.builtin").git_stash()
			end,
			desc = "[G]it [S]tash",
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
			"<leader>ht",
			require("telescope").extensions.harpoon.marks,
			{ desc = "[H]arpoon [T]elescope" }
		)

		vim.keymap.set("n", "<leader>sgc", function()
			builtin.live_grep({
				additional_args = function()
					return { "--glob", "*.cs" }
				end,
			})
		end, { desc = "[S]earch [G]rep only .cs files" })

		vim.keymap.set("n", "<leader>/", function()
			builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
				winblend = 10,
				previewer = false,
			}))
		end, { desc = "Fuzzy Search in Current Buffer" })

		vim.keymap.set("n", "<leader>s/", function()
			builtin.live_grep({
				grep_open_files = true,
				prompt_title = "Live Grep in Open Files",
			})
		end, { desc = "[S]earch [/] in Open Files" })

		vim.keymap.set("n", "<leader>sn", function()
			builtin.find_files({ cwd = vim.fn.stdpath("config") })
		end, { desc = "[S]earch [N]eovim config files" })

		-- Uncomment if needed:
		-- vim.keymap.set("n", "gr", builtin.lsp_references, { desc = "[G]oto [R]eferences" })
	end,
}
