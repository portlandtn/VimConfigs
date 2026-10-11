# Portability update validation

Prepared October 10, 2026 from `portlandtn/VimConfigs` main commit `c2a64922e5e9e2ee83bd9b6c30e35cdf15784e19`.

## Changes

- Removed unconditional WSL compiler environment overrides and machine-specific project paths.
- Initialized the Space leader before mappings; preserved split navigation and moved conflicting Harpoon navigation to Space hn/hp.
- Kept Blink as the sole completion engine; repaired discovery of the repository's C# JSON snippets and their constructor cursor placeholder.
- Migrated LSP setup to Neovim's configuration API and Mason v2 automatic enablement, following the [LSP documentation](https://github.com/neovim/nvim-lspconfig) and [Mason documentation](https://github.com/mason-org/mason-lspconfig.nvim).
- Added an installer with staging, automatic configuration backup, rollback on final rename failure, and preservation of local settings.
- Added dependency health checks, icon fallbacks, and optional AI/C# integration guards. Claude Code starts on demand.
- Preserved existing plugin revisions except for removing the unused completion engine and its sources. Made legacy Treesitter/textobjects and Harpoon branches explicit and stopped ignoring the tracked lockfile.
- Added installation, upgrade and rollback instructions and a three-OS CI workflow.
- Simplified DeleteFile to delete the confirmed file without rewriting a specific project's build file.

## Verified locally

All tests used isolated configuration/data/state/cache directories; the active user configuration was not changed.

| Check | Result |
| --- | --- |
| Download and restore pinned plugins in a fresh data directory | Passed |
| Linux startup smoke checks, official Neovim 0.11.3 | Passed |
| Linux startup smoke checks, installed Neovim 0.12.4 | Passed |
| Space leader mappings and single completion engine | Passed |
| Telescope file picker and Neo-tree open/close | Passed |
| Custom C# constructor snippet discovery | Passed |
| Lua syntax loading for installed configuration files | Passed |
| Startup with PATH restricted to Git/ripgrep; no compiler, Node, Claude CLI or .NET | Passed |
| No-compiler parser-install fallback | Passed |
| Fresh install, preservation of local.lua, and backup of prior configuration | Passed on both tested Neovim versions |
| Git diff whitespace checks | Passed |

The full-environment C# smoke check reports the expected warning that Roslyn is not installed. No C# server was downloaded or tested. Startup with the restricted PATH passes without that optional plugin.

## Remaining verification

The Windows/macOS matrix had not run during local validation; consult the pull request checks for current CI results. Native terminal rendering, OS clipboard providers, every Treesitter parser, language-server attachment/diagnostics, AI authentication, and installer failure recovery under filesystem/permission errors still need platform verification. Backup content preservation was tested; forced filesystem failure was not injected.

This is a portability and compatibility update, not a blanket plugin upgrade. New Treesitter and Roslyn APIs have different requirements; migrating them needs separate testing. No independent Claude or Copilot review was performed.

## Windows installer-test correction

The first GitHub matrix passed both Linux and macOS versions plus Windows stable, but Windows Neovim 0.11.3 failed while locating the backup with `glob()`. The preceding assertions confirmed that the replacement config existed, local settings survived, and the old sentinel was absent from the replacement.

The test now enumerates backup directory entries with libuv rather than interpreting the temporary path as a glob pattern. Its temporary path includes spaces and brackets, and child-process failures include both output streams. The revised installer checks pass locally on Neovim 0.11.3 and 0.12.4; see the PR checks for Windows confirmation.
