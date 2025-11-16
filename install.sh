#!/usr/bin/env bash

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Directories
DOTFILES_DIR="$HOME/dotfiles"
BACKUP_DIR="$HOME/.dotfiles_backup"

echo -e "${BLUE}=====================================${NC}"
echo -e "${BLUE}   Dotfiles Installation Script${NC}"
echo -e "${BLUE}=====================================${NC}\n"

# Function to print colored output
print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_info() {
    echo -e "${BLUE}→${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}!${NC} $1"
}

# Check if running on macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    print_warning "This script is optimized for macOS. Some steps may not work on other systems."
fi

# Create backup directory
if [ ! -d "$BACKUP_DIR" ]; then
    mkdir -p "$BACKUP_DIR"
    print_success "Created backup directory: $BACKUP_DIR"
fi

# Function to backup and symlink
backup_and_link() {
    local source=$1
    local target=$2

    # If target exists and is not a symlink, back it up
    if [ -e "$target" ] && [ ! -L "$target" ]; then
        print_info "Backing up existing $target"
        mv "$target" "$BACKUP_DIR/$(basename $target).$(date +%Y%m%d_%H%M%S)"
    fi

    # Remove existing symlink if it exists
    if [ -L "$target" ]; then
        rm "$target"
    fi

    # Create symlink
    ln -sf "$source" "$target"
    print_success "Linked $(basename $source) → $target"
}

# Check for Homebrew
echo -e "\n${BLUE}Checking dependencies...${NC}"
if ! command -v brew &> /dev/null; then
    print_warning "Homebrew not found. Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    print_success "Homebrew installed"
else
    print_success "Homebrew is installed"
fi

# Install packages from Brewfile
echo -e "\n${BLUE}Installing packages from Brewfile...${NC}"
if [ -f "$DOTFILES_DIR/Brewfile" ]; then
    print_info "Installing all packages, casks, and apps from Brewfile..."
    brew bundle --file="$DOTFILES_DIR/Brewfile"
    print_success "All packages installed from Brewfile"
else
    print_warning "Brewfile not found, skipping package installation"
fi

# Special handling for fzf key bindings
if command -v fzf &> /dev/null; then
    if [ ! -f "$HOME/.fzf.zsh" ]; then
        print_info "Installing fzf key bindings..."
        $(brew --prefix)/opt/fzf/install --key-bindings --completion --no-update-rc
    fi
fi

# Check for Oh My Zsh
echo -e "\n${BLUE}Checking for Oh My Zsh...${NC}"
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    print_warning "Oh My Zsh not found. Installing..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    print_success "Oh My Zsh installed"
else
    print_success "Oh My Zsh is installed"
fi

# Install Powerlevel10k theme
echo -e "\n${BLUE}Checking for Powerlevel10k theme...${NC}"
P10K_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
if [ ! -d "$P10K_DIR" ]; then
    print_info "Installing Powerlevel10k..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$P10K_DIR"
    print_success "Powerlevel10k installed"
else
    print_success "Powerlevel10k is installed"
fi

# Create symlinks for dotfiles
echo -e "\n${BLUE}Creating symlinks...${NC}"
backup_and_link "$DOTFILES_DIR/shell/zshrc" "$HOME/.zshrc"
backup_and_link "$DOTFILES_DIR/shell/p10k.zsh" "$HOME/.p10k.zsh"
backup_and_link "$DOTFILES_DIR/git/gitconfig" "$HOME/.gitconfig"
backup_and_link "$DOTFILES_DIR/git/gitignore_global" "$HOME/.gitignore_global"

# Final message
echo -e "\n${GREEN}=====================================${NC}"
echo -e "${GREEN}   Installation Complete!${NC}"
echo -e "${GREEN}=====================================${NC}\n"

echo -e "${BLUE}Next steps:${NC}"
echo -e "  1. Restart your terminal or run: ${YELLOW}source ~/.zshrc${NC}"
echo -e "  2. If this is your first time, run: ${YELLOW}p10k configure${NC}"
echo -e "  3. Your old dotfiles are backed up in: ${YELLOW}$BACKUP_DIR${NC}\n"

print_info "Test fzf with: Ctrl-R (history), Ctrl-T (files), Alt-C (directories)"
