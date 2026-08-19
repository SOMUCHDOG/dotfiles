# Dotfiles

Personal macOS configuration for zsh, tmux, neovim, and AeroSpace.

## What's included

| Tool | Config |
|------|--------|
| [AeroSpace](https://github.com/nikitabobko/AeroSpace) | `.aerospace.toml` |
| [tmux](https://github.com/tmux/tmux) | `.tmux.conf`, `.tmux/plugins/` |
| [Neovim](https://neovim.io/) | `.config/nvim/` |
| [zsh](https://www.zsh.org/) + [oh-my-zsh](https://ohmyz.sh/) | `.zshrc`, `.zprofile`, `.zshenv` |

## Setup on a new Mac

### 1. Install Homebrew

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### 2. Clone this repo into your home directory

```sh
git init ~
git remote add origin <your-repo-url>
git fetch
git checkout main
```

> If files already exist (e.g. `.zshrc`), back them up first before checking out.

### 3. Install dependencies

```sh
brew install tmux neovim eza fzf nvm go terraform
brew install --cask aerospace
```

For Node.js via nvm:
```sh
nvm install --lts
```

For Go version management via gvm (optional):
```sh
bash < <(curl -s -S -L https://raw.githubusercontent.com/moovweb/gvm/master/binscripts/gvm-installer)
```

### 4. Install oh-my-zsh

```sh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

> oh-my-zsh is tracked as a gitlink in this repo. After the initial `git checkout`, it should already be present at `~/.oh-my-zsh`. If not, install it manually with the command above.

### 5. Set up tmux plugins

TPM (Tmux Plugin Manager) and plugins are tracked as gitlinks and will be present after checkout. Start tmux and install plugins:

```sh
tmux
```

Then press `Ctrl+s` + `I` to install all plugins (dracula theme, vim-tmux-navigator).

### 6. Set up Neovim

[lazy.nvim](https://github.com/folke/lazy.nvim) is used as the plugin manager. On first launch, clone lazy.nvim manually (the config will bootstrap plugins after):

```sh
git clone --filter=blob:none https://github.com/folke/lazy.nvim.git \
  ~/.local/share/nvim/lazy/lazy.nvim
```

Then open Neovim and plugins will install automatically:

```sh
nvim
```

LSP servers are managed by [Mason](https://github.com/williamboman/mason.nvim). Run `:Mason` inside Neovim to install language servers as needed.

### 7. Launch AeroSpace

AeroSpace is set to `start-at-login = true` and will launch automatically after login. To start it immediately:

```sh
open -a AeroSpace
```

## Key bindings

### AeroSpace

| Key | Action |
|-----|--------|
| `cmd+h/j/k/l` | Focus window left/down/up/right |
| `alt+1-9` | Switch to workspace |
| `alt+shift+1-9` | Move window to workspace |
| `alt+shift+h/j/k/l` | Move window |
| `alt+/` | Toggle tiles layout |
| `alt+,` | Toggle accordion layout |
| `alt+tab` | Switch to previous workspace |
| `alt+shift+;` | Enter service mode |

### tmux (prefix: `Ctrl+s`)

| Key | Action |
|-----|--------|
| `Ctrl+s` + `r` | Reload config |
| `Ctrl+s` + `I` | Install plugins |
| `Ctrl+h/j/k/l` | Navigate panes (vim-tmux-navigator) |

### Neovim (leader: `Space`)

| Key | Action |
|-----|--------|
| `<leader>sf` | Find files (Telescope) |
| `<leader>sg` | Live grep (Telescope) |
| `<leader>sh` | Search help |
| `<leader>a` | Add file to Harpoon |
| `Ctrl+e` | Toggle Harpoon menu |
| `Alt+h/j/k/l` | Jump to Harpoon slots 1-4 |
