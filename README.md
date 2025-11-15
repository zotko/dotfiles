# Dotfiles

My personal macOS development environment configuration files.

## What's Included

- **Shell Configuration** (Zsh with Oh My Zsh)
  - `.zshrc` - Zsh configuration with fzf, vi-mode, and other plugins
  - `.p10k.zsh` - Powerlevel10k theme configuration
- **Git Configuration**
  - `.gitconfig` - Git aliases and settings
- **Bootstrap Script** - Automated setup for new machines

## Quick Start

### On a New Machine

```bash
# Clone this repository
git clone https://github.com/YOUR_USERNAME/dotfiles.git ~/dotfiles

# Run the install script
cd ~/dotfiles
./install.sh
```

### Manual Installation

If you prefer to set up manually:

```bash
# Create symlinks
ln -sf ~/dotfiles/shell/zshrc ~/.zshrc
ln -sf ~/dotfiles/shell/p10k.zsh ~/.p10k.zsh
ln -sf ~/dotfiles/git/gitconfig ~/.gitconfig

# Reload shell
source ~/.zshrc
```

## Prerequisites

The install script will check for and help install:

- [Homebrew](https://brew.sh/) - macOS package manager
- [Oh My Zsh](https://ohmyz.sh/) - Zsh framework
- [Powerlevel10k](https://github.com/romkatv/powerlevel10k) - Zsh theme
- Essential tools: `fzf`, `fd`, `bat`, `git`

## Customization

After installation, you can customize:

1. **Zsh Plugins**: Edit the `plugins=()` array in `shell/zshrc`
2. **Prompt Theme**: Run `p10k configure` to reconfigure Powerlevel10k
3. **fzf Options**: Modify `FZF_DEFAULT_OPTS` in `shell/zshrc`

## File Structure

```
dotfiles/
├── README.md           # This file
├── install.sh          # Bootstrap script
├── shell/
│   ├── zshrc          # Zsh configuration (symlinked to ~/.zshrc)
│   └── p10k.zsh       # Powerlevel10k config (symlinked to ~/.p10k.zsh)
└── git/
    └── gitconfig      # Git configuration (symlinked to ~/.gitconfig)
```

## Key Features

- **fzf Integration**: Fuzzy finding for files, history, and directories
  - `Ctrl-R` - Search command history
  - `Ctrl-T` - Search files
  - `Alt-C` - Change directory
- **Vi Mode**: Vi keybindings in the shell
- **Enhanced Tools**: Uses `fd` and `bat` for better performance and previews

## Updating

When you make changes to your dotfiles:

```bash
cd ~/dotfiles
git add .
git commit -m "Update configuration"
git push
```

On other machines, pull the latest changes:

```bash
cd ~/dotfiles
git pull
source ~/.zshrc  # Reload if shell configs changed
```

## Notes

- The install script backs up existing dotfiles to `~/.dotfiles_backup/`
- Oh My Zsh and plugins are NOT included in this repo (installed separately)
- Sensitive information (API keys, tokens) should never be committed
- For machine-specific config, use `~/.zshrc.local` (sourced if it exists)

## License

Feel free to use and modify as needed!
