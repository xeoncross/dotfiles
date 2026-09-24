# dotfiles

<p align="center">
  <a href="https://discord.gg/Wsy2NpnZDu"
    ><img
      alt="Discord"
      src="https://img.shields.io/discord/1439901831038763092?style=flat-square&label=discord"
  /></a>
</p>

Watch the walkthrough: https://youtu.be/5N-okeDdIuI

My personal Mac setup, managed with plain bash scripts and native tools.
One repo, one command, and a fresh Mac ends up configured the same way every time.

Homebrew installs every package from `Brewfile`. `scripts/links.sh` symlinks the config files under `home/` into place. `scripts/macos.sh` applies macOS settings with `defaults write`. No Nix required.

> This is a fork of https://github.com/kunchenguid/dotfiles to add my own tooling around vscode, language servers, local models, and other development needs.

## Contributing / Using This Repo

These are my personal dotfiles, shared publicly so people can read them, learn from them, and fork them freely.
Feature requests and pull requests are not accepted here, and PRs are auto-closed.
If you find a bug, please open a GitHub Issue using the bug report template.

## What you get

- Homebrew packages from `Brewfile`: CLI tools (ripgrep, fd, fzf, jq, lazygit, Neovim, starship, zsh plugins), apps (casks), the Hack Nerd Font, and VS Code with its extensions
- Global npm packages and `go install` tools that Homebrew doesn't ship (`scripts/packages.sh`)
- Shell (zsh, aliases, starship prompt) from `home/.zshrc` and `home/.config/starship.toml`
- Editor (Neovim config with the rose-pine moon theme)
- Terminal (WezTerm config with the rose-pine moon theme and dimmed unfocused windows)
- Agent configs (Claude, Codex, opencode all share one AGENTS.md)
- Optional Pi theme and local extensions, generic UI settings and model overrides, plus two deliberately pinned third-party Pi packages
- System settings from `scripts/macos.sh` (dark mode, key repeat, dock, Finder, trackpad)

## Prerequisites

- A Mac, Apple Silicon or Intel.
  The scripts look for Homebrew in both `/opt/homebrew` and `/usr/local`.

## Fresh-machine setup

On a brand new Mac, from a bare clone of this repo:

```sh
git clone https://github.com/kunchenguid/dotfiles.git
cd dotfiles
```

Before you run it: review "Make it yours" below, especially the Homebrew cleanup warning.

```sh
./bootstrap.sh
```

`bootstrap.sh` is idempotent: run it on a fresh Mac, and again after every change. It runs, in order:

1. Runs `scripts/homebrew.sh`: installs Homebrew with the official installer (which also installs the Xcode Command Line Tools) if it's missing, then installs everything in `Brewfile`.
2. Runs `scripts/links.sh`: symlinks the config files under `home/` into your home folder.
3. Runs `scripts/packages.sh`: global npm packages and `go install` tools.
4. Runs `scripts/macos.sh`: macOS settings, then restarts Dock and Finder.
   Key repeat changes may need a log out and back in.

Open a new terminal afterwards so the new `~/.zshrc` loads.

## Daily use

Edit the files in place, then re-run `./bootstrap.sh`, or just the script for what you changed (for example `scripts/homebrew.sh` after editing `Brewfile`).

To add a package, add a line to `Brewfile` (`brew`, `cask`, `tap`, or `vscode` for a VS Code extension).
Don't `brew install` things ad-hoc: the next run removes anything not in `Brewfile` (see the cleanup warning below).

Removing a line from `scripts/macos.sh` does not revert that setting; change it back by hand or with an explicit `defaults write`.

## Migrating from the Nix version

Earlier versions of this repo used nix-darwin, home-manager, nix-homebrew, and Determinate Nix.
`bootstrap.sh` refuses to run while `/opt/homebrew/.managed_by_nix_darwin` exists.
Migrate once, after pulling the new version:

```sh
DRY_RUN=1 ./uninstall_nix.sh   # preview
./uninstall_nix.sh
```

`uninstall_nix.sh` asks for confirmation, then:

1. Removes home-manager's symlinks from your home folder (only links into its last generation), its copied fonts, and its state.
2. Replaces nix-homebrew's `brew` (symlinks into `/nix/store`) with vanilla Homebrew from the official installer. Installed formulae, casks, and taps in `/opt/homebrew` are kept.
3. Runs nix-darwin's uninstaller, which restores the stock `/etc` files and removes its launchd services.
4. Runs Determinate's `/nix/nix-installer uninstall`, which removes `/nix`, then the per-user `~/.nix-profile`, `~/.nix-defexpr`, and `~/.local/state/nix`.

The Nix-installed CLI tools (nvim, rg, fd, starship, VS Code, and so on) are gone until the next step.
Open a new terminal and run `./bootstrap.sh` to install them from `Brewfile` and create the new links.

## Make it yours

This repo is mine.
If you clone it, review these before you run `bootstrap.sh`:

- `Brewfile` - the packages and apps you get, and the ones the cleanup keeps.
- `scripts/macos.sh` - the macOS settings.

**Git identity:** this config deliberately does not set your git name or email.
Git will stop your first commit and tell you to set them (`git config --global user.name "Your Name"` and `git config --global user.email you@example.com`).
If you'd rather keep it in the repo, add a `home/.gitconfig` with your identity and a matching `link` line in `scripts/links.sh`.

**Homebrew cleanup warning:** `scripts/homebrew.sh` runs `brew bundle cleanup --force --zap`.
That means every time you run `bootstrap.sh` or `scripts/homebrew.sh`, Homebrew removes any formula, cask, or tap on your machine that isn't listed in `Brewfile`, and zaps the removed casks' app data.
If you already have Homebrew stuff installed that isn't in that file, the first run will uninstall it.
Run `brew bundle cleanup --file Brewfile` (without `--force` it only lists) to see what would be removed, and add anything you want to keep to `Brewfile` before your first real run.

**About `herdr`:** it's in `Brewfile`.
It's a real public Homebrew formula (`brew info herdr` finds it in homebrew-core, no tap needed), so it will install fine.
If you don't use it, just remove it from `Brewfile` in your copy.

**Heads-up:**

- `home/AGENTS.md` is my personal agent policy, and `scripts/links.sh` installs it for Claude, Codex, and opencode.
  If you clone this repo, you'd silently inherit my agent instructions - edit or delete `home/AGENTS.md` if you don't want that.
- The `cc` and `co` shell aliases in `home/.zshrc` are high-agency shortcuts: `claude --dangerously-skip-permissions` and `codex --full-auto`.
  They're convenient for me, but know what they do before you use them.

## Repo tour

- `Brewfile` - every Homebrew formula, cask, tap, and VS Code extension. This is where packages go.
- `scripts/homebrew.sh` - installs Homebrew if needed, then makes the machine match `Brewfile`.
- `scripts/links.sh` - symlinks the files under `home/` into place.
- `scripts/packages.sh` - global npm packages and `go install` tools.
- `scripts/macos.sh` - macOS system settings via `defaults write`.
- `bootstrap.sh` - runs all of the scripts above. Use it for a fresh Mac and after every change.
- `uninstall_nix.sh` - one-time migration off the old Nix version of this repo.
- `home/` - the actual config files that get symlinked into place; the sections below explain the shared symlink model and Pi's narrower selective setup.

## How the symlinks work

The files under `home/` are the real files - editing them here is editing your live config, no rebuild needed to see the change.
`scripts/links.sh` points paths like `~/.config/nvim` straight at `home/.config/nvim` in this repo, so the two never drift out of sync.
If a real file is already in the way, `links.sh` moves it to `<name>.backup-<timestamp>` first.
Re-run it when you add a link or move the repo.

## Optional Pi configuration

Pi is an opt-in CLI, not a dependency this repository vendors. Install it from its owner with the [official Pi instructions](https://pi.dev), for example:

```sh
npm install -g --ignore-scripts @earendil-works/pi-coding-agent
```

[Pi Launcher](https://github.com/kunchenguid/homebrew-tap) is also optional and installed from its owner, not declared by this config:

```sh
brew install --cask kunchenguid/tap/pi-launcher
```

`scripts/links.sh` links exactly two repository-authored Pi directories: `~/.pi/agent/themes` and `~/.pi/agent/extensions`. It also links `models.json` and `settings.json` as individual files. The local extension directory is for public, repository-authored extensions only - third-party package code never belongs there. Run `/reload` after editing a local extension or other Pi resources. The terminal-title extension shows a spinner while Pi is working, then a completion mark with the session name or current directory. The `rose-pine-moon` theme was authored clean-room from the public [Rosé Pine Moon palette](https://rosepinetheme.com/palette) and Pi's [public theme schema](https://raw.githubusercontent.com/earendil-works/pi/main/packages/coding-agent/src/modes/interactive/theme/theme-schema.json), not from a private or live theme file.

### Pi Calm

`home/.pi/agent/extensions/calm` is a standalone local Pi extension. The existing extensions-directory link from `scripts/links.sh` makes Pi auto-load it without another declaration. `/calm` toggles a conversation-only presentation mode and is off by default. Its choice is stored locally in `~/.pi/agent/calm` (or the directory selected by `PI_CODING_AGENT_DIR`), not in this repository or `scripts/links.sh`. Adapted from Firstmate under the bundled MIT license, Calm imports no Firstmate modules and has no Firstmate runtime dependency.

When enabled, Calm hides collapsed thinking and the call/result shells for Pi's seven built-in tools (`read`, `bash`, `edit`, `write`, `grep`, `find`, and `ls`) without leaving blank transcript rows. During an active run it replaces Pi's working row with a two-line animated blue-water, yellow-boat widget. `/calm` restores Pi's stock rendering and preserves the existing Ctrl+O tool-expansion choice.

Calm never changes prompts, tool execution, model context, session data, or ordering. `/share` and `/export` use the complete stock transcript. Generic custom tools, images, and unsupported Pi transcript classes deliberately remain visible because Pi has no safe general-purpose transcript filter. If a future Pi release no longer exports the exact collapsed-thinking rendering seam, Calm logs one diagnostic and leaves only that adapter disabled; all other behavior remains available.

Pi's package system declares two third-party sources in the linked global `settings.json`:

- `npm:pi-web-access@0.14.0` - the exact public npm release for web access.
- `npm:@ryan_nookpi/pi-extension-codex-fast-mode@0.2.6` - the exact public npm release from `ryan_nookpi`.

The versions are immutable pins, so Pi does not move them during package updates. Deliberate updates require a new source and security audit, followed by an explicit pin change in `home/.pi/agent/settings.json`. On Pi 0.82.0, global settings declarations install missing pinned packages automatically at startup. No one-time install command is required. Pi keeps the downloaded npm package trees in its own unmanaged `~/.pi/agent/npm` runtime directory, outside `scripts/links.sh` and Git tracking.

Both packages execute with your full user permissions and must be trusted like any other executable code.

`scripts/links.sh` deliberately does not link `~/.pi/agent` itself, or Pi authentication, sessions, trust decisions, caches, npm/git package trees, or any other runtime state. The model overrides contain no credentials or endpoint settings, do not choose a default model, and only take effect after you authenticate Pi yourself. This remains an additive post-video layer: it does not install Pi, a launcher, or package source code into this repository.

## Notes

The first time you launch `nvim`, it bootstraps [lazy.nvim](https://github.com/folke/lazy.nvim) by cloning plugins from GitHub.
That needs network access once; after that it's offline.
Neovim and WezTerm both use the rose-pine moon theme.
Neovim keeps italics off and uses a transparent background on macOS, Windows, and WSL so it matches the terminal setup.

## License

This repo is licensed under MIT No Attribution.
See `LICENSE`.
