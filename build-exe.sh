#!/bin/bash
# Advanced build script for creating platform-specific executables
# This requires Love2D binaries to be downloaded first

set -e

BUILD_DIR="build"
GAME_NAME="lovely"
VERSION="1.0.0"
LOVE_VERSION="11.5"

# URLs for Love2D binaries (update these if needed)
LOVE_WIN64_URL="https://github.com/love2d/love/releases/download/${LOVE_VERSION}/love-${LOVE_VERSION}-win64.zip"
LOVE_WIN32_URL="https://github.com/love2d/love/releases/download/${LOVE_VERSION}/love-${LOVE_VERSION}-win32.zip"
LOVE_MACOS_URL="https://github.com/love2d/love/releases/download/${LOVE_VERSION}/love-${LOVE_VERSION}-macos.zip"

echo "========================================"
echo "Building $GAME_NAME v$VERSION"
echo "Platform-specific executables"
echo "========================================"

# Create build directory
mkdir -p "$BUILD_DIR"
mkdir -p "$BUILD_DIR/temp"

# Step 1: Create .love file
echo ""
echo "[1/4] Creating .love file..."
rm -f "$BUILD_DIR/$GAME_NAME.love"

zip -9 -q -r "$BUILD_DIR/$GAME_NAME.love" . \
    -x "build/*" \
    -x ".git/*" \
    -x ".gitignore" \
    -x "*.sh" \
    -x "*.bat" \
    -x "*.md" \
    -x ".vscode/*" \
    -x ".DS_Store"

echo "✓ Created $GAME_NAME.love"

# Function to build Windows executable
build_windows() {
    local arch=$1
    local url=$2
    local output_dir="$BUILD_DIR/${GAME_NAME}-win${arch}"

    echo ""
    echo "[2/4] Building Windows ${arch}-bit executable..."

    # Download Love2D if not cached
    local love_zip="$BUILD_DIR/temp/love-win${arch}.zip"
    if [ ! -f "$love_zip" ]; then
        echo "Downloading Love2D ${arch}-bit..."
        curl -L "$url" -o "$love_zip"
    fi

    # Extract Love2D
    rm -rf "$output_dir"
    mkdir -p "$output_dir"
    unzip -q "$love_zip" -d "$BUILD_DIR/temp/"

    # Find the extracted folder
    local love_dir=$(find "$BUILD_DIR/temp" -maxdepth 1 -type d -name "love-*-win${arch}" | head -n 1)

    # Copy Love2D files
    cp -r "$love_dir"/* "$output_dir/"

    # Fuse .love with love.exe to create game.exe
    cat "$output_dir/love.exe" "$BUILD_DIR/$GAME_NAME.love" > "$output_dir/$GAME_NAME.exe"
    rm "$output_dir/love.exe"

    # Clean up extracted folder
    rm -rf "$love_dir"

    echo "✓ Created Windows ${arch}-bit build in: $output_dir"
}

# Function to build macOS app
build_macos() {
    local output_dir="$BUILD_DIR/${GAME_NAME}-macos"

    echo ""
    echo "[3/4] Building macOS app..."

    # Download Love2D if not cached
    local love_zip="$BUILD_DIR/temp/love-macos.zip"
    if [ ! -f "$love_zip" ]; then
        echo "Downloading Love2D for macOS..."
        curl -L "$LOVE_MACOS_URL" -o "$love_zip"
    fi

    # Extract Love2D
    rm -rf "$output_dir"
    mkdir -p "$output_dir"
    unzip -q "$love_zip" -d "$output_dir/"

    # Rename love.app to game name
    mv "$output_dir/love.app" "$output_dir/$GAME_NAME.app"

    # Copy .love into the app bundle
    cp "$BUILD_DIR/$GAME_NAME.love" "$output_dir/$GAME_NAME.app/Contents/Resources/"

    # Update Info.plist with game name
    if [ -f "$output_dir/$GAME_NAME.app/Contents/Info.plist" ]; then
        sed -i.bak "s/>LÖVE</>$GAME_NAME</g" "$output_dir/$GAME_NAME.app/Contents/Info.plist"
        rm "$output_dir/$GAME_NAME.app/Contents/Info.plist.bak"
    fi

    echo "✓ Created macOS build in: $output_dir"
}

# Build for all platforms
build_windows "64" "$LOVE_WIN64_URL"
build_windows "32" "$LOVE_WIN32_URL"
build_macos

# Create distribution packages
echo ""
echo "[4/4] Creating distribution archives..."

cd "$BUILD_DIR"
zip -9 -q -r "${GAME_NAME}-win64.zip" "${GAME_NAME}-win64"
zip -9 -q -r "${GAME_NAME}-win32.zip" "${GAME_NAME}-win32"
zip -9 -q -r "${GAME_NAME}-macos.zip" "${GAME_NAME}-macos"
cd ..

# Cleanup
rm -rf "$BUILD_DIR/temp"

echo ""
echo "========================================"
echo "Build complete!"
echo "========================================"
echo "Outputs:"
echo "  - $BUILD_DIR/$GAME_NAME.love (universal)"
echo "  - $BUILD_DIR/${GAME_NAME}-win64.zip"
echo "  - $BUILD_DIR/${GAME_NAME}-win32.zip"
echo "  - $BUILD_DIR/${GAME_NAME}-macos.zip"
echo "========================================"
