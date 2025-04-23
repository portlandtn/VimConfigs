return {
	"ThePrimeagen/harpoon",
	dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim" },
	config = function()
		require("harpoon").setup({})
		require("telescope").load_extension("harpoon")

		-- Move your Harpoon keymaps here:
		local mark = require("harpoon.mark")
		local ui = require("harpoon.ui")

		vim.keymap.set("n", "<leader>a", mark.add_file, { desc = "[H]arpoon [A]dd File" })
		vim.keymap.set("n", "<leader>harp", ui.toggle_quick_menu, { desc = "[H]arpoon [M]enu" })
		vim.keymap.set("n", "<leader>1", function()
			ui.nav_file(1)
		end, { desc = "Harpoon File 1" })
		vim.keymap.set("n", "<leader>2", function()
			ui.nav_file(2)
		end, { desc = "Harpoon File 2" })
		vim.keymap.set("n", "<leader>3", function()
			ui.nav_file(3)
		end, { desc = "Harpoon File 3" })
		vim.keymap.set("n", "<leader>4", function()
			ui.nav_file(4)
		end, { desc = "Harpoon File 4" })
	end,
}
