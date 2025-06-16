# Home Manager Configuration

This repository contains my personal Home Manager configuration for macOS (Apple Silicon).

## Overview

This configuration manages various command-line tools and applications using Nix/Home Manager. It includes setup for:

### Shell Environment
- Fish shell (primary)
- Zsh (alternative)
- Starship prompt
- Tmux
- Common CLI tools (bat, eza, fzf, ripgrep, etc.)

### Development Tools
- Git configuration
- Neovim
- lazygit
- Programming languages:
  - Go
  - Java (OpenJDK 21)

### Terminal Configuration
- Ghostty terminal settings
- Custom file management with Yazi
- FZF integration
- Various shell aliases and functions

## Structure
```
.
├── flake.nix          # Nix flake configuration
├── home.nix           # Main home-manager configuration
├── modules/
│   └── shell.nix      # Shell-related configurations
└── dotfiles/
    └── starship.toml  # Starship prompt configuration
```

## Usage

To apply the configuration:

```bash
home-manager switch --flake .#devonwalker
```

## System Requirements

- macOS (Apple Silicon)
- Nix package manager
- Home Manager
