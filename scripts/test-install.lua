local uv = vim.uv
local root = vim.fs.normalize(vim.fn.tempname() .. " installer [paths]")
local source = assert(uv.cwd())
local target = root .. "/config/vimconfigs-install-test"
local env = {
	NVIM_APPNAME = "vimconfigs-install-test",
	XDG_CONFIG_HOME = root .. "/config",
	XDG_DATA_HOME = root .. "/data",
	XDG_STATE_HOME = root .. "/state",
	XDG_CACHE_HOME = root .. "/cache",
}
local function install()
	local result = vim.system({ vim.v.progpath, "-l", source .. "/scripts/install.lua" }, { env = env, text = true })
		:wait()
	assert(result.code == 0, (result.stdout or "") .. (result.stderr or ""))
end
local ok, err = xpcall(function()
	install()
	assert(vim.fn.filereadable(target .. "/init.lua") == 1)
	vim.fn.writefile({ "return 'local settings retained'" }, target .. "/local.lua")
	vim.fn.writefile({ "previous configuration" }, target .. "/sentinel.txt")
	install()
	assert(vim.fn.readfile(target .. "/local.lua")[1] == "return 'local settings retained'")
	assert(vim.fn.filereadable(target .. "/sentinel.txt") == 0)
	-- Inspect directory entries directly: path characters and Windows separators
	-- must not be interpreted as glob syntax.
	local backups = {}
	local entries = assert(uv.fs_scandir(root .. "/config"))
	while true do
		local name, kind = uv.fs_scandir_next(entries)
		if not name then
			break
		end
		if kind == "directory" and name:match("^vimconfigs%-install%-test%.backup%-") then
			table.insert(backups, vim.fs.joinpath(root, "config", name))
		end
	end
	assert(#backups == 1, "Expected exactly one backup; found " .. #backups)
	assert(vim.fn.readfile(backups[1] .. "/sentinel.txt")[1] == "previous configuration")
end, debug.traceback)
vim.fn.delete(root, "rf")
if not ok then
	error(err)
end
print("Installer fresh install, backup and local-settings checks passed")
