#!/bin/bash

# Installation script for AI Command Line Helper

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}AI Command Line Helper - Installation Script${NC}"
echo

# Check if we're on macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    echo -e "${YELLOW}Warning: This tool was designed for macOS. It may work on other Unix systems but hasn't been tested.${NC}"
fi

# Check if ollama is installed
if ! command -v ollama &> /dev/null; then
    echo -e "${RED}Error: Ollama is not installed${NC}"
    echo "Please install Ollama first:"
    echo "  brew install ollama"
    echo "  or visit: https://ollama.ai"
    exit 1
fi

echo -e "${GREEN}✓ Ollama found${NC}"

# Check if llama3.2 model is available
if ! ollama list | grep -q "llama3.2"; then
    echo -e "${YELLOW}Warning: llama3.2 model not found${NC}"
    echo -n "Would you like to download it now? [y/N]: "
    read -r response
    if [[ "$response" =~ ^[yY]$ ]]; then
        echo "Downloading llama3.2..."
        ollama pull llama3.2
    else
        echo -e "${YELLOW}You can download it later with: ollama pull llama3.2${NC}"
    fi
fi

# Determine installation directory
INSTALL_DIR="$HOME/.local/bin"
if [[ ":$PATH:" != *":$INSTALL_DIR:"* ]]; then
    # Check common directories in PATH
    for dir in "$HOME/bin" "/usr/local/bin" "$HOME/.local/bin"; do
        if [[ ":$PATH:" == *":$dir:"* ]] && [[ -w "$dir" ]] 2>/dev/null; then
            INSTALL_DIR="$dir"
            break
        fi
    done
fi

# Create install directory if it doesn't exist
mkdir -p "$INSTALL_DIR"

# Copy the script
echo "Installing ai-helper to $INSTALL_DIR..."
cp ai-helper "$INSTALL_DIR/"
chmod +x "$INSTALL_DIR/ai-helper"

echo -e "${GREEN}✓ ai-helper installed to $INSTALL_DIR${NC}"

# Check if install directory is in PATH
if [[ ":$PATH:" != *":$INSTALL_DIR:"* ]]; then
    echo -e "${YELLOW}Warning: $INSTALL_DIR is not in your PATH${NC}"
    echo "Add this line to your ~/.zshrc:"
    echo "  export PATH=\"$INSTALL_DIR:\$PATH\""
fi

# Offer to add to shell configuration
echo
echo -n "Would you like to add the 'ai' function to your ~/.zshrc for easy access? [y/N]: "
read -r response

if [[ "$response" =~ ^[yY]$ ]]; then
    # Add source line to .zshrc if not already present
    ZSHRC="$HOME/.zshrc"
    SOURCE_LINE="source $INSTALL_DIR/ai-helper"
    
    if ! grep -q "$SOURCE_LINE" "$ZSHRC" 2>/dev/null; then
        echo "" >> "$ZSHRC"
        echo "# AI Command Line Helper" >> "$ZSHRC"
        echo "$SOURCE_LINE" >> "$ZSHRC"
        echo -e "${GREEN}✓ Added to ~/.zshrc${NC}"
        echo -e "${YELLOW}Run 'source ~/.zshrc' or restart your terminal to use the 'ai' function${NC}"
    else
        echo -e "${YELLOW}Already present in ~/.zshrc${NC}"
    fi
fi

echo
echo -e "${GREEN}Installation complete!${NC}"
echo
echo -e "${BLUE}Usage:${NC}"
echo "  ai-helper kill the process using port 8080"
echo "  ai-helper llama3.1 find all .js files modified today"
echo
echo "If you added it to ~/.zshrc, you can also use:"
echo "  ai kill the process using port 8080"
echo "  ai llama3.1 find all .js files modified today"
echo
echo -e "${BLUE}Environment Variables:${NC}"
echo "  OLLAMA_MODEL - Set default model (default: llama3.2)"
echo "  export OLLAMA_MODEL=llama3.1"
echo
echo -e "${YELLOW}Note: Make sure Ollama service is running with 'ollama serve'${NC}" 