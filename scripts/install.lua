-- Run from any directory: nvim -l /path/to/VimConfigs/scripts/install.lua
local uv = vim.uv
local source = vim.fs.dirname(vim.fs.dirname(debug.getinfo(1, "S").source:sub(2)))
source = assert(uv.fs_realpath(source))
local target = vim.fn.stdpath("config")
if uv.fs_realpath(target) == source then
	print("VimConfigs is already in " .. target)
	return
end

local function copy(from, to)
	local stat = assert(uv.fs_stat(from), "Cannot read " .. from)
	if stat.type == "directory" then
		vim.fn.mkdir(to, "p")
		local entries = assert(uv.fs_scandir(from))
		while true do
			local name = uv.fs_scandir_next(entries)
			if not name then
				break
			end
			copy(from .. "/" .. name, to .. "/" .. name)
		end
	else
		assert(uv.fs_copyfile(from, to))
	end
end

-- Stage first so a copy failure leaves the existing configuration untouched.
local stage = target .. ".vimconfigs-stage-" .. uv.os_getpid()
assert(not uv.fs_lstat(stage), "Staging directory already exists: " .. stage)
vim.fn.mkdir(stage, "p")
local ok, err = pcall(function()
	for _, name in ipairs({ "init.lua", "lua", "lazy-lock.json" }) do
		copy(source .. "/" .. name, stage .. "/" .. name)
	end
	-- Retain local settings on upgrades.
	if vim.fn.filereadable(target .. "/local.lua") == 1 then
		copy(target .. "/local.lua", stage .. "/local.lua")
	end
end)
if not ok then
	vim.fn.delete(stage, "rf")
	error(err)
end
local backup
if uv.fs_lstat(target) then
	backup = target .. ".backup-" .. os.date("%Y%m%d-%H%M%S") .. "-" .. uv.os_getpid()
	assert(not uv.fs_lstat(backup), "Backup already exists: " .. backup)
	assert(uv.fs_rename(target, backup))
end
local installed, install_error = uv.fs_rename(stage, target)
if not installed then
	if backup then
		assert(uv.fs_rename(backup, target))
	end
	vim.fn.delete(stage, "rf")
	error(install_error)
end
print("Installed VimConfigs in " .. target)
if backup then
	print("Previous configuration saved in " .. backup)
end
print("Open nvim to install plugins, then run :checkhealth custom")
