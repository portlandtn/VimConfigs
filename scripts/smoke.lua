local function check()
	assert(vim.g.mapleader == " ", "Leader must be set before mappings")
	assert(vim.fn.maparg(" config", "n") ~= "", "Portable config mapping missing")
	assert(vim.fn.maparg("\\q", "n") == "", "Mapping captured the default leader")
	assert(vim.fn.exists(":Hide") == 2 and vim.fn.exists(":Unhide") == 2)
	local plugins = require("lazy.core.config").plugins
	assert(plugins["blink.cmp"] and not plugins["nvim-cmp"], "Use one completion engine")
	assert(vim.lsp.config.lua_ls.settings.Lua.completion.callSnippet == "Replace")
	vim.cmd("edit smoke.lua")
	vim.cmd("doautocmd InsertEnter")
	assert(require("blink.cmp"))
	vim.bo.filetype = "cs"
	vim.wait(200, function()
		return false
	end)
	local found = false
	for _, snippet in ipairs(require("luasnip").get_snippets("cs")) do
		found = found or snippet.name == "Constructor"
	end
	assert(found, "Repository C# snippets did not load")
	if vim.env.VIMCONFIGS_TEST_MINIMAL == "1" then
		assert(not plugins["copilot.vim"] and not plugins["claudecode.nvim"] and not plugins["roslyn.nvim"])
		local specs = dofile(vim.fn.stdpath("config") .. "/lua/custom/plugins/treesitter.lua")
		assert(#specs[1].opts().ensure_installed == 0, "Parser installs must be skipped without a compiler")
	end
	require("telescope.builtin").find_files({ cwd = vim.fn.stdpath("config") })
	require("telescope.actions").close(vim.api.nvim_get_current_buf())
	vim.cmd("Neotree show")
	vim.cmd("Neotree close")
	for _, file in ipairs(vim.fn.globpath(vim.fn.stdpath("config"), "**/*.lua", false, true)) do
		assert(loadfile(file), "Invalid Lua: " .. file)
	end
	vim.wait(200, function()
		return false
	end)
	assert(vim.v.errmsg == "", vim.v.errmsg)
end
local ok, err = xpcall(check, debug.traceback)
if not ok then
	io.stderr:write(err .. "\n")
	vim.cmd("cquit 1")
end
print("VimConfigs smoke checks passed")
vim.cmd("qa!")
