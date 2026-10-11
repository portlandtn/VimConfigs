# VimConfigs

Jed's portable **Neovim** configuration for Windows, macOS, and Linux. This is not a Vim `.vimrc`. It includes file search, a file tree, Git tools, completion, Lua language support, formatting, snippets, and optional C# and AI integrations.

## Requirements

Install **Neovim 0.11.3 or newer**, **Git**, and **ripgrep** (`rg`) and make them available on PATH. An internet connection is required for initial plugin and language-tool downloads. The committed `lazy-lock.json` records plugin revisions; use those revisions for reproducible installs.

Examples (check `nvim --version` afterward; some Linux distribution packages are older):

- Windows PowerShell: `winget install Neovim.Neovim`, `winget install Git.Git`, and `winget install BurntSushi.ripgrep.MSVC`. Restart the terminal after installation.
- macOS with Homebrew: `brew install neovim git ripgrep`.
- Debian/Ubuntu: `sudo apt install git ripgrep`; install a sufficiently recent Neovim from its [official releases](https://github.com/neovim/neovim/releases).

## Install on any platform

Run these commands in PowerShell on Windows or your shell on macOS/Linux:

```sh
git clone https://github.com/portlandtn/VimConfigs.git
cd VimConfigs
nvim -l scripts/install.lua
nvim
```

The installer uses `stdpath("config")`, copies the configuration, and backs up an existing configuration to a sibling `nvim.backup-<timestamp>-<pid>` directory. It does not require symlinks or administrator access. Existing `local.lua` settings are carried forward. Close other Neovim instances before installing.

Default destinations:

| Platform | Config directory |
| --- | --- |
| Windows | `%LOCALAPPDATA%\nvim` |
| macOS / Linux | `~/.config/nvim` |
| WSL | `~/.config/nvim` inside the Linux environment |

`XDG_CONFIG_HOME` and `NVIM_APPNAME` overrides are honored. WSL and native Windows have separate plugin binaries and should have separate data directories.

On first startup, Lazy installs the locked plugins. Wait for downloads/builds to finish, restart Neovim, and run `:checkhealth custom`. Lua's language server and StyLua are installed through Mason during an interactive startup; inspect `:Mason` if downloads fail. Plugin or tool installation requires network access and the relevant download/extraction utilities (`:checkhealth mason`).

To try the config separately before adopting it, set `NVIM_APPNAME=vimconfigs-test` in your shell before running the installer and Neovim. In PowerShell use `$env:NVIM_APPNAME = 'vimconfigs-test'`. Unset it afterward to return to your normal config.

## Optional tools

- **C compiler** (`cc`, `gcc`, `clang`, `cl`, or `zig`): Treesitter parser compilation. On macOS use `xcode-select --install`; on Linux install your distribution's build tools; on Windows use a native compiler, for example LLVM, or launch from a Visual Studio developer shell. Without a compiler, initial parser installation is skipped and ordinary syntax highlighting remains available. After installing a compiler, restart Neovim. Windows never uses WSL compilers. The optional Telescope native sorter is only built on Unix when both Make and a compiler are present; search works without it.
- **Clipboard provider**: macOS uses `pbcopy`, Windows uses its native provider, Linux typically needs `wl-clipboard` for Wayland or `xclip`/`xsel` for X11. Check `:checkhealth vim.provider`, especially over SSH or in WSL.
- **Nerd Font**: select one in your terminal and enable icons in `local.lua` with `vim.g.have_nerd_font = true`, or set `NVIM_NERD_FONT=1`. Icons default off.
- **Copilot**: install a supported Node.js version, then run `:Copilot setup` and authenticate. The plugin is disabled when `node` is missing. Accept suggestions with Ctrl-J in insert mode.
- **Claude Code**: install and authenticate the `claude` CLI on PATH. The integration is disabled when it is absent and loads on demand with `:ClaudeCode` when available.
- **C#**: install the .NET SDK and the Roslyn language server. With the pinned Roslyn plugin, add `github:Crashdummyy/mason-registry` to Mason's registries and run `:MasonInstall roslyn`, following the [pinned plugin instructions](https://github.com/seblyng/roslyn.nvim/tree/24f7c91ee5e09c63104deaab68f932620f25c24a). Restart Neovim after installing the server. C# syntax/snippets work without a language server; diagnostics and navigation require it. The config does not install project SDKs or change project files.

## Local settings

Create `local.lua` in the installed config directory for machine-specific settings. It loads before options, mappings, and plugins and is ignored by Git. For example:

```lua
vim.g.have_nerd_font = true
```

Keep personal project paths and compiler overrides here rather than in shared files.

## Common keys

The leader is **Space**.

| Key | Action |
| --- | --- |
| Space sf / sg | Find files / search contents |
| Space e | Toggle file tree |
| Space config | Open the active config directory |
| Space f | Format buffer |
| gd / grr / Space rr | Definition / references / rename |
| Space a / harp | Add Harpoon mark / open marks menu |
| Space hn / hp | Next / previous Harpoon mark |
| Ctrl-h/j/k/l | Move between splits |
| Ctrl-y | Accept Blink completion |
| jj or kk | Leave insert mode |

`:Hide` / `:Unhide` control netrw filtering. `:DeleteFile` asks before deleting the current file; it no longer rewrites a hard-coded project's `.csproj`.

## Updating and rollback

After pulling changes into this checkout, rerun `nvim -l scripts/install.lua` to copy them into the active config. Then run `nvim --headless "+Lazy! restore" +qa` to match the committed plugin revisions. The installed directory is a copy, not a Git checkout. Restore your previous configuration by closing Neovim, moving the installed config aside, and renaming its backup to the original config directory. Plugin/data directories are not backed up by this installer.

For deliberate plugin upgrades, use `:Lazy update`, test the changes, and copy the resulting lockfile from the installed config back to this repository before committing. Treesitter and its textobjects stay on `master` for their existing configuration API, and Harpoon stays on `master` for its existing mappings. Moving these to their newer APIs is a separate migration. Updating Roslyn to its current main branch may also raise the Neovim minimum version.

## Verification

The GitHub Actions workflow installs into an isolated `NVIM_APPNAME` on Linux, macOS, and Windows, using Neovim 0.11.3 and stable. It restores locked plugins and exercises startup, leader mappings, completion loading, file search, and the file tree:

```sh
nvim --headless "+lua dofile('scripts/smoke.lua')"
```

The workflow must run on GitHub before its platform results can be claimed. It does not verify AI authentication, clipboard integration, C# server behavior, every parser, or terminal rendering. Local validation and remaining limits are recorded in `VALIDATION.md`.
