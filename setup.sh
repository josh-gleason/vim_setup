#!/bin/bash

# Variables
NEOVIM_URL="https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz"
NODEJS_VERSION="v20.17.0"   # LTS version
NODEJS_DISTRO="linux-x64"
NODEJS_URL="https://nodejs.org/dist/$NODEJS_VERSION/node-$NODEJS_VERSION-$NODEJS_DISTRO.tar.xz"
INSTALL_DIR="$HOME/.local"
BIN_DIR="$HOME/.local/bin"
CONFIG_DIR="$HOME/.config/nvim"
INIT_LUA_PATH="$CONFIG_DIR/init.lua"
BACKUP_DIR="$CONFIG_DIR/backup"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TIMESTAMP=$(date +"%Y%m%d%H%M%S")

# Create necessary directories
mkdir -p "$BIN_DIR" "$CONFIG_DIR" "$BACKUP_DIR"

# Download Neovim Tarball
echo "Downloading Neovim..."
curl -L "$NEOVIM_URL" -o "/tmp/nvim-linux64.tar.gz"

# Extract Neovim
echo "Extracting Neovim..."
tar xzf "/tmp/nvim-linux64.tar.gz" -C "$INSTALL_DIR"

# Create a symlink to nvim
ln -sf "$INSTALL_DIR/nvim-linux64/bin/nvim" "$BIN_DIR/nvim"

# Create a symlink from nvim to vim if vim is not already installed
if [ ! -e "$BIN_DIR/vim" ]; then
    echo "No vim found at $BIN_DIR. Creating symlink from nvim to vim..."
    ln -sf "$BIN_DIR/nvim" "$BIN_DIR/vim"
    echo "Symlink created: $BIN_DIR/vim -> $BIN_DIR/nvim"
else
    echo "vim already exists at $BIN_DIR. Skipping symlink creation."
fi

# Function to compare versions
version_ge() {
    # Returns true if version $1 >= version $2
    [ "$(printf '%s\n' "${1#v}" "${2#v}" | sort -V | head -n1)" = "${2#v}" ]
}

# Check if Node.js is already installed and meets the version requirement
NODE_INSTALLED=false
if command -v node >/dev/null 2>&1; then
    INSTALLED_NODE_VERSION=$(node -v)
    if version_ge "$INSTALLED_NODE_VERSION" "$NODEJS_VERSION"; then
        echo "Node.js $INSTALLED_NODE_VERSION is already installed and meets the version requirement."
        NODE_INSTALLED=true
    else
        echo "Node.js $INSTALLED_NODE_VERSION is installed but does not meet the version requirement."
    fi
else
    echo "Node.js is not installed."
fi

if [ "$NODE_INSTALLED" = false ]; then
    # Download Node.js
    echo "Downloading Node.js..."
    curl -L "$NODEJS_URL" -o "/tmp/node-$NODEJS_VERSION-$NODEJS_DISTRO.tar.xz"

    # Extract Node.js
    echo "Extracting Node.js..."
    tar xf "/tmp/node-$NODEJS_VERSION-$NODEJS_DISTRO.tar.xz" -C "$INSTALL_DIR"

    # Create symlinks to node, npm, and npx
    ln -sf "$INSTALL_DIR/node-$NODEJS_VERSION-$NODEJS_DISTRO/bin/node" "$BIN_DIR/node"
    ln -sf "$INSTALL_DIR/node-$NODEJS_VERSION-$NODEJS_DISTRO/bin/npm" "$BIN_DIR/npm"
    ln -sf "$INSTALL_DIR/node-$NODEJS_VERSION-$NODEJS_DISTRO/bin/npx" "$BIN_DIR/npx"
else
    echo "Skipping Node.js installation."
fi

# Ensure ~/.local/bin is in PATH
if ! echo "$PATH" | grep -q "$BIN_DIR"; then
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.bashrc"
    export PATH="$HOME/.local/bin:$PATH"
    echo "$BIN_DIR added to PATH."
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
nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'

# Install coc-pyright using CocInstall
echo "Installing coc-pyright..."
nvim --headless -c 'CocInstall -sync coc-pyright|q' +q

# Clean up temporary files
echo "Cleaning up temporary files..."
rm -f "/tmp/nvim-linux64.tar.gz"
rm -f "/tmp/node-$NODEJS_VERSION-$NODEJS_DISTRO.tar.xz"

echo "Neovim installation and setup complete."

