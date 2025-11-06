#!/bin/bash
# Build web version for GitHub Pages
set -e

echo "========================================"
echo "Building Web Version"
echo "========================================"

# Build the .love file first
echo "Step 1: Building .love file..."
bash build.sh

# Build web version with love.js
echo "Step 2: Converting to web with love.js..."
npx love.js build/lovely.love web --title "Lovely - Egg Drop Game" --memory 33554432

# Copy service worker for SharedArrayBuffer support
echo "Step 3: Adding SharedArrayBuffer support..."
cp coi-serviceworker.js web/coi-serviceworker.js

echo "========================================"
echo "Web build complete!"
echo "Output: web/"
echo ""
echo "To test locally: npm run serve"
echo "To deploy: npm run deploy"
echo "========================================"
