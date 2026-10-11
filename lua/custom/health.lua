local M = {}
function M.check()
	local health = vim.health
	health.start("VimConfigs")
	if vim.fn.has("nvim-0.11.3") == 1 then
		health.ok("Neovim >= 0.11.3")
	else
		health.error("Install Neovim >= 0.11.3")
	end
	for _, tool in ipairs({ "git", "rg" }) do
		if vim.fn.executable(tool) == 1 then
			health.ok(tool .. " is available")
		else
			health.error("Install " .. tool .. " and add it to PATH")
		end
	end
	local compiler = false
	for _, tool in ipairs({ "cc", "gcc", "clang", "cl", "zig" }) do
		compiler = compiler or vim.fn.executable(tool) == 1
	end
	if compiler then
		health.ok("C compiler is available for Treesitter")
	else
		health.warn("No C compiler: automatic parser installation is skipped; built-in syntax remains available")
	end
	for tool, purpose in pairs({ node = "Copilot", claude = "Claude Code", dotnet = "C# language support" }) do
		if vim.fn.executable(tool) == 1 then
			health.ok(tool .. " is available (" .. purpose .. ")")
		else
			health.warn("Optional: " .. tool .. " is missing (" .. purpose .. ")")
		end
	end
	local roslyn = vim.fn.has("win32") == 1 and "roslyn.cmd" or "roslyn"
	if
		vim.fn.executable("dotnet") == 1
		and vim.fn.executable(roslyn) == 0
		and vim.fn.executable("Microsoft.CodeAnalysis.LanguageServer") == 0
	then
		health.warn(".NET is available but Roslyn is missing; see the README's C# setup instructions")
	end
	if vim.fn.executable("pbcopy") == 1 then
		health.ok("macOS clipboard available")
	else
		health.info("Run :checkhealth vim.provider to check clipboard support for this terminal/session")
	end
	health.info("Config: " .. vim.fn.stdpath("config"))
	health.info("Set NVIM_NERD_FONT=1 or vim.g.have_nerd_font=true in local.lua to enable icons")
end
return M
