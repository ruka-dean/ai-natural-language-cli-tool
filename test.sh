#!/bin/bash

# Test script for AI Command Line Helper

set -e

echo "🧪 Testing AI Command Line Helper"
echo "================================="
echo

# Test 1: Check if script is executable
echo "Test 1: Checking if ai-helper is executable..."
if [[ -x "./ai-helper" ]]; then
    echo "✅ ai-helper is executable"
else
    echo "❌ ai-helper is not executable"
    echo "Run: chmod +x ai-helper"
    exit 1
fi

# Test 2: Check basic help output
echo
echo "Test 2: Checking help output..."
if ./ai-helper 2>&1 | grep -q "AI Command Line Helper"; then
    echo "✅ Help output looks correct"
else
    echo "❌ Help output not found"
    exit 1
fi

# Test 3: Check if ollama is available
echo
echo "Test 3: Checking Ollama availability..."
if command -v ollama &> /dev/null; then
    echo "✅ Ollama is installed"
    
    # Check if ollama service is running
    if ollama list &> /dev/null; then
        echo "✅ Ollama service is running"
        
        # Check for available models
        if ollama list | grep -q "llama3.2"; then
            echo "✅ llama3.2 model is available"
        else
            echo "⚠️  llama3.2 model not found"
            echo "   You can install it with: ollama pull llama3.2"
        fi
    else
        echo "⚠️  Ollama service might not be running"
        echo "   Try: ollama serve"
    fi
else
    echo "❌ Ollama is not installed"
    echo "   Install with: brew install ollama"
fi

# Test 4: Check zsh compatibility
echo
echo "Test 4: Checking zsh compatibility..."
if [[ "$SHELL" == *"zsh"* ]] || [[ -n "$ZSH_VERSION" ]]; then
    echo "✅ Running in zsh environment"
else
    echo "⚠️  Not running in zsh (current shell: $SHELL)"
    echo "   This tool is designed for zsh"
fi

# Test 5: Source test (dry run)
echo
echo "Test 5: Testing source functionality..."
if zsh -c "source ./ai-helper && echo 'Source test successful'" 2>/dev/null; then
    echo "✅ Script can be sourced successfully"
else
    echo "❌ Error sourcing script"
fi

echo
echo "🎉 Basic tests completed!"
echo
echo "To test the full functionality:"
echo "1. Make sure Ollama is running: ollama serve"
echo "2. Try a safe command: ./ai-helper list files in current directory"
echo "3. Or source it: source ./ai-helper && ai list files in current directory"
echo "4. Test multi-command: ./ai-helper create a test directory and list its contents"
echo
echo "Multi-command features:"
echo "- The tool can generate multiple commands for complex tasks"
echo "- You can choose to execute all commands, step through individually, or skip"
echo "- Interactive mode allows skipping individual commands while executing all"
echo "- Each command is confirmed before execution for safety"
echo
echo "Remember: The tool will always ask for confirmation before executing commands!" 