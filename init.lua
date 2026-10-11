-- Initialization
if vim.fn.has("nvim-0.11.3") == 0 then
	error("VimConfigs requires Neovim 0.11.3 or newer (not Vim).")
end

-- Set leaders before any mappings are defined.
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.have_nerd_font = vim.env.NVIM_NERD_FONT == "1"

-- Optional machine-specific settings; never tracked in Git.
local local_config = vim.fn.stdpath("config") .. "/local.lua"
if vim.fn.filereadable(local_config) == 1 then
	dofile(local_config)
end

-- Hide files we don't normally care about
vim.g.netrw_list_hide = [[\(^\|\s\s\)\(\.git\|\.gitignore\|\.gitattributes\|node_modules\|\.DS_Store\)\($\|/\)]]
vim.g.netrw_hide = 1
vim.g.netrw_banner = 0

function _G.HideFiles()
	vim.g.netrw_hide = 1
	print("Netrw: Hiding hidden files")
	-- Auto-refresh netrw if it's open
	vim.cmd("Lexplore!")
end

function _G.UnhideFiles()
	vim.g.netrw_hide = 0
	print("Netrw: Unhiding hidden files")
	-- Auto-refresh netrw if it's open
	vim.cmd("edit .")
end

-- external files
require("custom.keymaps")
require("custom.options")

-- [[ Setting options ]]
-- See `:help vim.opt`
-- NOTE: You can change these options as you wish!
--  For more options, you can see `:help option-list`

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		error("Error cloning lazy.nvim:\n" .. out)
	end
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

-- [[ Configure and install plugins ]]
--
--  To check the current status of your plugins, run
--    :Lazy
--
--  You can press `?` in this menu for help. Use `:q` to close the window
--
--  To update plugins you can run
--    :Lazy update
--
-- NOTE: Here is where you install your plugins.
require("lazy").setup({
	{ import = "custom.plugins" },
	{ import = "custom.plugins.folke" },
	-- NOTE: Plugins can be added with a link (or for a github repo: 'owner/repo' link).
	"tpope/vim-sleuth", -- Detect tabstop and shiftwidth automatically
	"https://github.com/ThePrimeagen/vim-be-good.git",
}, {
	checker = { enabled = false },
	ui = {
		-- If you are using a Nerd Font: set icons to an empty table which will use the
		-- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
		icons = vim.g.have_nerd_font and {} or {
			cmd = "⌘",
			config = "🛠",
			event = "📅",
			ft = "📂",
			init = "⚙",
			keys = "🗝",
			plugin = "🔌",
			runtime = "💻",
			require = "🌙",
			source = "📄",
			start = "🚀",
			task = "📌",
			lazy = "💤 ",
		},
	},
})

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
-- Testing here
-- require("nvim-autopairs").setup({})
