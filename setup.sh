#!/bin/bash

# Variables
NEOVIM_URL="https://github.com/neovim/neovim/releases/latest/download/nvim.appimage"
INSTALL_DIR="$HOME/.local/bin"
CONFIG_DIR="$HOME/.config/nvim"
INIT_LUA_PATH="$CONFIG_DIR/init.lua"
BACKUP_DIR="$CONFIG_DIR/backup"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TIMESTAMP=$(date +"%Y%m%d%H%M%S")

# Create necessary directories
mkdir -p "$INSTALL_DIR"
mkdir -p "$CONFIG_DIR"
mkdir -p "$BACKUP_DIR"

# Download Neovim AppImage
echo "Downloading Neovim..."
curl -L "$NEOVIM_URL" -o "$INSTALL_DIR/nvim.appimage"
chmod u+x "$INSTALL_DIR/nvim.appimage"

# Create a symlink to nvim
ln -sf "$INSTALL_DIR/nvim.appimage" "$INSTALL_DIR/nvim"

# Ensure ~/.local/bin is in PATH
if ! echo "$PATH" | grep -q "$INSTALL_DIR"; then
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.bashrc"
    export PATH="$HOME/.local/bin:$PATH"
    echo "$INSTALL_DIR added to PATH."
fi

# Backup existing init.lua if it exists
if [ -f "$INIT_LUA_PATH" ]; then
    echo "Backing up existing init.lua..."
    cp "$INIT_LUA_PATH" "$BACKUP_DIR/init.lua.backup.$TIMESTAMP"
fi

# Copy the new init.lua from the script's directory
if [ -f "$SCRIPT_DIR/init.lua" ]; then
    echo "Copying init.lua from script directory..."
    cp "$SCRIPT_DIR/init.lua" "$INIT_LUA_PATH"
else
    echo "Error: init.lua not found in the script directory."
    exit 1
fi

# Install Packer if not already installed
PACKER_DIR="$HOME/.local/share/nvim/site/pack/packer/start/packer.nvim"
if [ ! -d "$PACKER_DIR" ]; then
    echo "Installing Packer..."
    git clone --depth 1 https://github.com/wbthomason/packer.nvim "$PACKER_DIR"
fi

# Install plugins
echo "Installing plugins..."
nvim --headless +PackerSync +qa

echo "Neovim installation and setup complete."

