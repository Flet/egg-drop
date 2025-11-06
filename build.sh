#!/bin/bash
# Build script for creating distributable Love2D game
# Generates a .love file that can be run with Love2D

set -e  # Exit on error

BUILD_DIR="build"
GAME_NAME="lovely"
VERSION="1.0.0"

echo "========================================"
echo "Building $GAME_NAME v$VERSION"
echo "========================================"

# Create build directory
mkdir -p "$BUILD_DIR"

# Clean previous builds
rm -f "$BUILD_DIR/$GAME_NAME.love"

echo "Creating .love file..."

# Create .love file (which is just a renamed zip)
# Include all game files except build artifacts, git, and dev files
zip -9 -r "$BUILD_DIR/$GAME_NAME.love" . \
    -x "build/*" \
    -x "web/*" \
    -x ".git/*" \
    -x ".github/*" \
    -x ".gitignore" \
    -x "*.sh" \
    -x "*.md" \
    -x ".vscode/*" \
    -x "*.bat" \
    -x ".DS_Store" \
    -x "node_modules/*" \
    -x "package.json" \
    -x "package-lock.json" \
    -x "serve-web.js" \
    -x "*.jpg" \
    -x "*.png" \
    -x "plan/*"

echo "========================================"
echo "Build complete!"
echo "Output: $BUILD_DIR/$GAME_NAME.love"
echo ""
echo "To run: love $BUILD_DIR/$GAME_NAME.love"
echo "Or double-click the .love file if Love2D is associated"
echo "========================================"
