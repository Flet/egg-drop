# Build Instructions

This document describes how to build and distribute **Lovely** - a Love2D egg-drop puzzle game.

## Prerequisites

- **Love2D 11.5+** installed on your system
- **Git** (optional, for version control)
- **zip** utility (included on most systems)

## Quick Build - .love File

The simplest way to distribute your game is as a `.love` file, which can be run by anyone with Love2D installed.

### Windows

```batch
build.bat
```

### Linux/macOS

```bash
chmod +x build.sh
./build.sh
```

This creates `build/lovely.love` which can be run with:
```bash
love build/lovely.love
```

## Advanced Build - Platform Executables

To create standalone executables that don't require Love2D to be installed:

### Linux/macOS

```bash
chmod +x build-exe.sh
./build-exe.sh
```

This script will:
1. Create the `.love` file
2. Download Love2D binaries for each platform
3. Fuse them with your game
4. Create distribution archives

**Output files:**
- `build/lovely.love` - Universal Love2D file
- `build/lovely-win64.zip` - Windows 64-bit executable
- `build/lovely-win32.zip` - Windows 32-bit executable
- `build/lovely-macos.zip` - macOS app bundle

### Windows (Manual Process)

For Windows executables on a Windows system:

1. Download Love2D Windows binaries from https://love2d.org/
2. Extract the zip file
3. Build the .love file using `build.bat`
4. Concatenate love.exe with your .love file:
   ```batch
   copy /b love.exe+build\lovely.love lovely.exe
   ```
5. Distribute `lovely.exe` along with all DLLs from the Love2D folder

## Manual Build

If you prefer to build manually:

```bash
# Create a zip file with all game files
zip -9 -r lovely.love \
    conf.lua \
    main.lua \
    src/ \
    lib/ \
    levels/ \
    assets/

# Rename to .love extension
mv lovely.zip lovely.love

# Run it
love lovely.love
```

## What Gets Included

The build scripts include:
- `conf.lua` - Love2D configuration
- `main.lua` - Main entry point
- `src/` - Source code
- `lib/` - Third-party libraries (lurker, lume)
- `levels/` - Level definitions
- `assets/` - Images, sounds, fonts (if any)

**Excluded from builds:**
- `.git/` - Git repository
- `build/` - Previous builds
- `.vscode/` - Editor settings
- `*.md` - Documentation files
- `*.sh`, `*.bat` - Build scripts
- `.gitignore`

## Distribution

### For Users With Love2D
Distribute `lovely.love` - smallest file size, requires Love2D installed.

### For General Users
Distribute platform-specific archives:
- Windows users: `lovely-win64.zip`
- macOS users: `lovely-macos.zip`

## File Sizes

Approximate distribution sizes:
- `.love` file: ~50-100 KB (just your game)
- Windows exe: ~5-10 MB (includes Love2D runtime)
- macOS app: ~10-15 MB (includes Love2D runtime)

## Troubleshooting

### "zip: command not found"
Install zip utility:
- **Ubuntu/Debian**: `sudo apt-get install zip`
- **macOS**: Included by default
- **Windows**: Use PowerShell (build.bat handles this)

### ".love file won't open"
- Ensure Love2D is installed
- Associate `.love` files with Love2D
- Or run from command line: `love game.love`

### "Permission denied" on Linux/macOS
Make scripts executable:
```bash
chmod +x build.sh build-exe.sh
```

## Publishing

### Itch.io
1. Upload `.love` file and platform-specific archives
2. Mark which files are for which platforms
3. Recommend users download Love2D or use platform builds

### GitHub Releases
1. Create a new release/tag
2. Attach all build artifacts
3. Include installation instructions in release notes

### Steam (requires Steamworks SDK)
Love2D games can be published on Steam - see Love2D documentation for details.

## Version Management

Update version numbers in:
- `build.sh` - `VERSION` variable
- `build.bat` - `VERSION` variable
- `build-exe.sh` - `VERSION` variable
- Your game code (if displaying version)

## Next Steps

After building:
1. Test the build on a clean system
2. Verify all assets load correctly
3. Check that hot-reload is disabled in release builds
4. Write player-facing README with controls and gameplay info
5. Create screenshots/trailer for distribution page
