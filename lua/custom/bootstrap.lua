-- Pin selected from this repository's existing lazy-lock.json.
local M = { revision = "306a05526ada86a7b30af95c5cc81ffba93fef97" }
function M.ensure(target, deps)
  deps = deps or {
    exists = function(p) return vim.uv.fs_stat(p) ~= nil end,
    run = function(args) return vim.system(args, { text = true }):wait(30000) end,
    remove = function(p) vim.fn.delete(p, "rf") end,
    rename = function(a, b) return vim.uv.fs_rename(a, b) end,
  }
  local function run(args)
    local result = deps.run(args)
    if result.code ~= 0 then error("lazy.nvim bootstrap Git operation failed or timed out; check network/Git and retry. Existing installation was not replaced.") end
    return (result.stdout or ""):gsub("%s+$", "")
  end
  local function verify(dir)
    if run({ "git", "-C", dir, "rev-parse", "HEAD" }) ~= M.revision then
      error("lazy.nvim revision mismatch. Back up/review the existing plugin and restore the documented pinned commit before startup.")
    end
    if run({ "git", "-C", dir, "status", "--porcelain", "--untracked-files=all" }) ~= "" then
      error("lazy.nvim contains local changes; review them before loading plugin code.")
    end
  end
  if deps.exists(target) then verify(target); return target end
  local stage = target .. ".bootstrap-" .. vim.uv.os_getpid()
  if deps.exists(stage) then error("lazy.nvim staging path already exists; inspect it before retrying.") end
  local ok, err = pcall(function()
    run({ "git", "clone", "--filter=blob:none", "--no-checkout", "https://github.com/folke/lazy.nvim.git", stage })
    run({ "git", "-C", stage, "checkout", "--detach", M.revision })
    verify(stage)
    assert(deps.rename(stage, target), "Could not install staged lazy.nvim")
  end)
  if not ok then deps.remove(stage); error(err) end
  return target
end
return M
