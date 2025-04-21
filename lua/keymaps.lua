-- keymaps.lua
local keymap = vim.keymap.set

keymap("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear highlights" })
keymap("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Diagnostic Quickfix" })
keymap("n", "<leader>rr", vim.lsp.buf.rename, { desc = "Rename symbol" })
keymap("n", "<leader>.", vim.lsp.buf.code_action, { desc = "Code Action" })
keymap("n", "gd", vim.lsp.buf.definition, { desc = "[G]oto [D]efinition" })
keymap("n", "gb", "<C-o>", { desc = "[G]o [B]ack" })
keymap("n", "<leader>o", ":put _<CR>", { desc = "Insert blank line below" })
keymap("n", "<leader>O", ":put! _<CR>", { desc = "Insert blank line above" })

keymap("n", "<A-j>", ":m .+1<CR>==", { desc = "Move line down", silent = true })
keymap("n", "<A-k>", ":m .-2<CR>==", { desc = "Move line up", silent = true })
keymap("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move block down", silent = true })
keymap("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move block up", silent = true })

keymap("n", "]e", function()
	vim.diagnostic.jump({ count = 1, severity = vim.diagnostic.severity.ERROR })
end, { desc = "Jump to next ERROR" })

keymap("n", "[e", function()
	vim.diagnostic.jump({ count = -1, severity = vim.diagnostic.severity.ERROR })
end, { desc = "Jump to previous ERROR" })

keymap("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

keymap("n", "<C-h>", "<C-w><C-h>", { desc = "Move to left window" })
keymap("n", "<C-l>", "<C-w><C-l>", { desc = "Move to right window" })
keymap("n", "<C-j>", "<C-w><C-j>", { desc = "Move to lower window" })
keymap("n", "<C-k>", "<C-w><C-k>", { desc = "Move to upper window" })
