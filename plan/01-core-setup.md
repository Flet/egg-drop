# Step 01: Core Setup

## Goal

Set up the foundational Love2D project structure with proper configuration and entry point. This creates the skeleton that all other systems will build upon.

## Dependencies

- None (this is the first step)
- Requires Love2D installed on system

## Files to Create/Modify

### Create
- `conf.lua` - Love2D configuration
- `main.lua` - Entry point (basic version, will enhance in step 14)
- Directory structure for project organization
- `.gitignore` - Exclude unnecessary files from git

### Modify
- None (clean start)

## Implementation Details

### 1. Create Project Directory Structure

Create the following folders:

```
lovely/
├── lib/              # Third-party libraries (add later)
├── src/              # Source code
│   ├── states/       # Game states
│   ├── entities/     # Game entities
│   ├── systems/      # Core systems
│   ├── objects/      # Reusable objects
│   ├── shaders/      # GLSL shaders
│   └── utils/        # Utilities
├── levels/           # Level definitions
├── assets/           # Game assets
│   ├── images/
│   ├── sounds/
│   └── fonts/
└── plan/             # Implementation plans (already exists)
```

**Commands:**
```bash
mkdir -p lib src/states src/entities src/systems src/objects src/shaders src/utils levels assets/images assets/sounds assets/fonts
```

### 2. Create conf.lua

This file configures Love2D before the game starts. It sets window size, title, enables/disables modules, etc.

**File: `conf.lua`**

```lua
function love.conf(t)
    -- Game identity (used for save data folder)
    t.identity = "lovely-egg-drop"
    t.version = "11.5"  -- Love2D version compatibility

    -- Window configuration
    t.window.title = "Egg Drop"
    t.window.icon = nil
    t.window.width = 1280
    t.window.height = 720
    t.window.borderless = false
    t.window.resizable = false
    t.window.minwidth = 1280
    t.window.minheight = 720
    t.window.fullscreen = false
    t.window.fullscreentype = "desktop"
    t.window.vsync = 1  -- Enable vsync for smooth 60fps
    t.window.msaa = 0   -- No anti-aliasing (we want crisp pixels)
    t.window.display = 1
    t.window.highdpi = false
    t.window.x = nil
    t.window.y = nil

    -- Modules to enable/disable
    t.modules.audio = true
    t.modules.data = true
    t.modules.event = true
    t.modules.font = true
    t.modules.graphics = true
    t.modules.image = true
    t.modules.joystick = false  -- Disable joystick (not needed)
    t.modules.keyboard = true
    t.modules.math = true
    t.modules.mouse = true
    t.modules.physics = false   -- Disable Box2D (custom physics)
    t.modules.sound = true
    t.modules.system = true
    t.modules.thread = false    -- Disable threading (not needed)
    t.modules.timer = true
    t.modules.touch = false     -- Disable touch (not needed)
    t.modules.video = false     -- Disable video (not needed)
    t.modules.window = true

    -- Console (useful for debugging on Windows)
    t.console = true  -- Set to false for release builds

    -- Accelerometer (mobile)
    t.accelerometerjoystick = false

    -- Audio
    t.audio.mixwithsystem = true
end
```

**Key Settings Explained:**
- `t.identity`: Name for save data folder
- `t.window.*`: Window dimensions and settings
- `t.window.vsync = 1`: Locks to 60fps (smooth rendering)
- `t.window.msaa = 0`: Disables anti-aliasing (want pixel-perfect)
- `t.modules.physics = false`: We're using custom physics, not Box2D
- `t.console = true`: Shows console for debug output (disable for release)

### 3. Create main.lua (Basic Version)

This is the entry point. We'll start simple and enhance it with hot-reload in step 14.

**File: `main.lua`**

```lua
-- Egg Drop Game
-- Main entry point

-- Global configuration
DEBUG = true

function love.load()
    -- Disable filtering for crisp pixel art
    love.graphics.setDefaultFilter("nearest", "nearest")

    -- Set background color (will be replaced by gradient later)
    love.graphics.setBackgroundColor(0, 0.85, 0.85)  -- Cyan

    -- Print startup info
    print("=================================")
    print("Egg Drop Game - Starting...")
    print("Love2D Version: " .. love.getVersion())
    print("Resolution: 320x240 → 1280x720")
    print("=================================")

    -- TODO: Initialize game systems (will add in later steps)
end

function love.update(dt)
    -- TODO: Update game state (will add in later steps)
end

function love.draw()
    -- Temporary test rendering
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Egg Drop Game - Core Setup Complete", 20, 20)
    love.graphics.print("Press ESC to quit", 20, 40)
    love.graphics.print("FPS: " .. love.timer.getFPS(), 20, 60)
end

function love.keypressed(key)
    -- ESC to quit
    if key == "escape" then
        love.event.quit()
    end
end
```

**Key Points:**
- `love.graphics.setDefaultFilter("nearest", "nearest")`: Critical for pixel art
- Debug flag for development features
- Basic FPS counter
- ESC to quit (standard game convention)

### 4. Create .gitignore

Prevent unnecessary files from being committed to git.

**File: `.gitignore`**

```gitignore
# Love2D
*.love

# Operating System
.DS_Store
Thumbs.db
desktop.ini

# IDE
.vscode/
.idea/
*.sublime-*

# Logs
*.log

# Temporary files
*~
*.swp
*.swo
*.tmp

# Build artifacts
dist/
build/
release/

# Assets that might be large or generated
# assets/**/*.psd
# assets/**/*.xcf
```

### 5. Create Empty Placeholder Files

Add `.gitkeep` files to empty directories so they're tracked by git:

**Files:**
- `lib/.gitkeep`
- `assets/images/.gitkeep`
- `assets/sounds/.gitkeep`
- `assets/fonts/.gitkeep`

These ensure the folder structure exists in git even when folders are empty.

## Testing

### 1. Verify Directory Structure

Run:
```bash
ls -R
```

Should show all folders created.

### 2. Run the Game

From the project root:
```bash
love .
```

**Expected Result:**
- Window opens at 1280x720
- Title bar shows "Egg Drop"
- Cyan background color
- White text showing "Core Setup Complete"
- FPS counter displays
- Console window shows startup info (on Windows)

### 3. Test ESC Key

Press ESC → Game should quit cleanly

### 4. Check Console Output

Console should display:
```
=================================
Egg Drop Game - Starting...
Love2D Version: 11.5.0
Resolution: 320x240 → 1280x720
=================================
```

### 5. Verify No Errors

No error messages in console or on screen.

## Common Issues

### Issue: "No game" or "No code to run"

**Cause:** Running `love` from wrong directory

**Fix:** Make sure you're in the `lovely/` directory and run `love .` (note the dot)

### Issue: Window wrong size

**Cause:** conf.lua not being read

**Fix:** Make sure conf.lua is in the same directory as main.lua

### Issue: Blurry text/graphics

**Cause:** Forgot to set nearest-neighbor filtering

**Fix:** Verify `love.graphics.setDefaultFilter("nearest", "nearest")` is in love.load()

### Issue: Console not showing (Windows)

**Cause:** t.console = false in conf.lua

**Fix:** Set t.console = true for development

## Next Steps

Once core setup is complete and tested:
- Proceed to [02-rendering-pipeline.md](02-rendering-pipeline.md)
- This will set up the canvas system for 320x240 rendering

## Notes

- Keep DEBUG = true during development
- Set t.console = false before releasing game
- All paths are relative to main.lua location
- Love2D looks for conf.lua and main.lua in the root directory
- Game can be packaged as .love file later (zip of project)

## Checklist

- [ ] All directories created
- [ ] conf.lua created with correct settings
- [ ] main.lua created and functional
- [ ] .gitignore created
- [ ] .gitkeep files in empty asset folders
- [ ] Game runs without errors
- [ ] Window is correct size (1280x720)
- [ ] Graphics are crisp (not blurry)
- [ ] ESC key quits game
- [ ] Console shows startup message
- [ ] FPS counter displays

## Estimated Time

15-30 minutes (mostly file creation and testing)
