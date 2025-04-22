-- [[ Basic Keymaps ]]
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Diagnostic keymaps
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- Custom KeyMappings
vim.keymap.set("n", "<leader>e", ":Neotree toggle<CR>", { desc = "Toggle File Explorer" })
vim.keymap.set("n", "<leader>er", vim.diagnostic.open_float, { desc = "Show diagnostic float" })
vim.keymap.set("n", "<leader>rr", vim.lsp.buf.rename, { desc = "Rename Symbol" })
vim.keymap.set("n", "<leader>.", vim.lsp.buf.code_action, { desc = "Code Action" })
vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "[G]oto [D]efinition" })
vim.keymap.set("n", "gb", "<C-o>", { desc = "[G]o [B]ack" })
vim.keymap.set("n", "<leader>config", ":Explore C:/Users/Jed.May/AppData/Local/nvim<CR>", { desc = "Explore Config" })
vim.keymap.set(
	"n",
	"<leader>nafx",
	":Explore C:/Users/Jed.May/source/repos/NAFX.Encompass/src/Plugin<CR>",
	{ desc = "Explore NAFx.Encompass" }
)

-- Toggle hide/unhide files
vim.api.nvim_create_user_command("Hide", HideFiles, {})
vim.api.nvim_create_user_command("Unhide", UnhideFiles, {})

-- Jump to next ERROR
-- Error navigation
vim.keymap.set("n", "]e", function()
	vim.diagnostic.jump({
		count = 1,
		severity = vim.diagnostic.severity.ERROR,
	})
end, { desc = "Jump to next ERROR" })

-- Jump to previous ERROR
vim.keymap.set("n", "[e", function()
	vim.diagnostic.jump({

		count = -1,

		severity = vim.diagnostic.severity.ERROR,
	})
end, { desc = "Jump to previous ERROR" })

-- Move lines around
vim.keymap.set("n", "<A-j>", ":m .+1<CR>==", { desc = "Move line down", silent = true })
vim.keymap.set("n", "<A-k>", ":m .-2<CR>==", { desc = "Move line up", silent = true })

-- Visual mode versions (for selected blocks)
vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move block down", silent = true })
vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move block up", silent = true })

--vim.keymap.set("v", "<leader>rm", vim.lsp.buf.range_code_action, { desc = "Refactor Method" })

vim.keymap.set("n", "<leader>vg", function()
	local term = vim.fn.input("Search .cs files for: ")
	if term ~= "" then
		vim.cmd("vimgrep /" .. term .. "/ **/*.cs")
		vim.cmd("copen")
	end
end, { desc = "Find in .cs files" })

-- NOTE: Some terminals have colliding keymaps or are not able to send distinct keycodes
-- vim.keymap.set("n", "<C-S-h>", "<C-w>H", { desc = "Move window to the left" })
-- vim.keymap.set("n", "<C-S-l>", "<C-w>L", { desc = "Move window to the right" })
-- vim.keymap.set("n", "<C-S-j>", "<C-w>J", { desc = "Move window to the lower" })
-- vim.keymap.set("n", "<C-S-k>", "<C-w>K", { desc = "Move window to the upper" })

-- custom user commands
vim.api.nvim_create_user_command("DeleteFile", function()
	local filepath = vim.fn.expand("%:p")
	local filename = vim.fn.expand("%:t")

	-- Step 1: Confirm deletion
	if vim.fn.confirm("Delete file?\n" .. filepath, "&Yes\n&No", 2) ~= 1 then
		print("Cancelled.")
		return
	end

	-- Step 2: Delete the file
	local ok, err = os.remove(filepath)
	if not ok then
		print("Error deleting file: " .. err)
		return
	end

	-- Step 3: Look upward specifically for Plugin.csproj
	local csproj_path = vim.fs.find("Plugin.csproj", { upward = true })[1]
	if not csproj_path then
		print("Plugin.csproj not found.")
		vim.cmd("bd!")
		return
	end

	-- Step 4: Remove the matching <Compile Include="..."> line
	local lines = vim.fn.readfile(csproj_path)
	local cleaned = {}
	local removed = false

	for _, line in ipairs(lines) do
		if line:match('<Compile Include=".*' .. filename .. '"%s*/>') then
			removed = true
		else
			table.insert(cleaned, line)
		end
	end

	if removed then
		vim.fn.writefile(cleaned, csproj_path)
		print("Removed reference to " .. filename .. " from Plugin.csproj")
	else
		print("No matching <Compile Include> for " .. filename .. " in Plugin.csproj")
	end

	-- Step 5: Close buffer
	vim.cmd("bd!")
end, { desc = "Delete current file and remove from Plugin.csproj" })
