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

# Patch index.html to load the service worker and add mobile support
echo "Step 4: Patching index.html for mobile and SharedArrayBuffer..."
sed -i '/<meta charset="utf-8">/a\    <script src="coi-serviceworker.js"><\/script>' web/index.html
sed -i 's/<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no, minimum-scale=1, maximum-scale=1">/<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">/' web/index.html
sed -i '/<link rel="stylesheet" type="text\/css" href="theme\/love.css">/r mobile-patch.html' web/index.html

echo "========================================"
echo "Web build complete!"
echo "Output: web/"
echo ""
echo "To test locally: npm run serve"
echo "To deploy: npm run deploy"
echo "========================================"
