# Step 02: Rendering Pipeline

## Goal

Implement a low-resolution rendering system that draws the game at 320x240 pixels, then scales it up to the 1280x720 window. This creates the authentic retro pixel art look while allowing modern high-resolution displays.

## Dependencies

- **Step 01**: Core setup must be complete
- conf.lua and main.lua must exist

## Files to Create/Modify

### Create
- `src/systems/renderer.lua` - Canvas rendering system

### Modify
- `main.lua` - Initialize and use renderer

## Implementation Details

### 1. Understanding the Rendering Pipeline

The rendering flow:
```
1. Create 320x240 canvas (low-res render target)
2. Draw all game objects to canvas at 1x scale
3. (Later) Apply shader to canvas
4. Scale canvas to fit window (4x zoom with letterboxing)
5. Use nearest-neighbor filtering (crisp pixels, no blur)
```

**Why this approach:**
- Game code works at native 320x240 (simpler math)
- Automatic pixel-perfect scaling
- Easy to add shaders/effects
- Consistent look across different screen sizes

### 2. Create Renderer System

**File: `src/systems/renderer.lua`**

```lua
-- Renderer system
-- Handles low-res canvas rendering and scaling to window

local Renderer = {}

function Renderer:init()
    -- Game native resolution
    self.gameWidth = 320
    self.gameHeight = 240

    -- Create canvas at game resolution
    self.canvas = love.graphics.newCanvas(self.gameWidth, self.gameHeight)

    -- Set canvas filter to nearest-neighbor (crisp pixels)
    self.canvas:setFilter("nearest", "nearest")

    -- Window dimensions
    self.windowWidth = love.graphics.getWidth()
    self.windowHeight = love.graphics.getHeight()

    -- Calculate scaling and letterboxing
    self:calculateScale()

    print("Renderer initialized:")
    print("  Game resolution: " .. self.gameWidth .. "x" .. self.gameHeight)
    print("  Window size: " .. self.windowWidth .. "x" .. self.windowHeight)
    print("  Scale: " .. self.scale .. "x")
    print("  Letterbox offset: " .. self.offsetX .. ", " .. self.offsetY)
end

function Renderer:calculateScale()
    -- Calculate how much we can scale while fitting in window
    local scaleX = self.windowWidth / self.gameWidth
    local scaleY = self.windowHeight / self.gameHeight

    -- Use the smaller scale to ensure game fits in window
    -- Force integer scaling for pixel-perfect rendering
    self.scale = math.floor(math.min(scaleX, scaleY))

    -- Calculate letterbox offsets to center the game
    local scaledWidth = self.gameWidth * self.scale
    local scaledHeight = self.gameHeight * self.scale

    self.offsetX = (self.windowWidth - scaledWidth) / 2
    self.offsetY = (self.windowHeight - scaledHeight) / 2
end

function Renderer:startDrawing()
    -- Set render target to the low-res canvas
    love.graphics.setCanvas(self.canvas)
    love.graphics.clear()
end

function Renderer:finishDrawing()
    -- Reset render target to screen
    love.graphics.setCanvas()

    -- Clear screen with black (letterbox bars)
    love.graphics.clear(0, 0, 0)

    -- Draw the scaled canvas to screen
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(
        self.canvas,
        self.offsetX,
        self.offsetY,
        0,  -- rotation
        self.scale,  -- scale X
        self.scale   -- scale Y
    )
end

function Renderer:getGameDimensions()
    return self.gameWidth, self.gameHeight
end

function Renderer:resize(w, h)
    -- Handle window resize (if enabled in future)
    self.windowWidth = w
    self.windowHeight = h
    self:calculateScale()
end

-- Convert screen coordinates to game coordinates
function Renderer:screenToGame(screenX, screenY)
    local gameX = (screenX - self.offsetX) / self.scale
    local gameY = (screenY - self.offsetY) / self.scale
    return gameX, gameY
end

-- Convert game coordinates to screen coordinates
function Renderer:gameToScreen(gameX, gameY)
    local screenX = gameX * self.scale + self.offsetX
    local screenY = gameY * self.scale + self.offsetY
    return screenX, screenY
end

return Renderer
```

**Key Functions:**
- `init()`: Creates canvas, calculates scaling
- `startDrawing()`: Sets render target to low-res canvas
- `finishDrawing()`: Draws canvas to screen with scaling
- `screenToGame()`: Convert mouse coords to game coords (useful later)
- `gameToScreen()`: Convert game coords to screen coords

### 3. Update main.lua

Replace the entire file with:

**File: `main.lua`**

```lua
-- Egg Drop Game
-- Main entry point

-- Global configuration
DEBUG = true

-- Systems
local Renderer = require("src.systems.renderer")

function love.load()
    -- Disable filtering for crisp pixel art
    love.graphics.setDefaultFilter("nearest", "nearest")

    print("=================================")
    print("Egg Drop Game - Starting...")
    print("Love2D Version: " .. love.getVersion())
    print("=================================")

    -- Initialize renderer
    Renderer:init()

    -- Store game dimensions for easy access
    GAME_WIDTH, GAME_HEIGHT = Renderer:getGameDimensions()
end

function love.update(dt)
    -- TODO: Update game state (will add in later steps)
end

function love.draw()
    -- Start drawing to low-res canvas
    Renderer:startDrawing()

    -- === GAME RENDERING (at 320x240) ===

    -- Draw gradient background (cyan to blue)
    drawGradientBackground()

    -- Draw test content
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Egg Drop Game", 10, 10)
    love.graphics.print("Rendering: 320x240", 10, 25)
    love.graphics.print("Window: 1280x720", 10, 40)
    love.graphics.print("Press ESC to quit", 10, 55)

    -- Draw test shapes to verify pixel-perfect rendering
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("fill", 100, 100, 4, 4)  -- 4x4 square (peg size)

    love.graphics.setColor(1, 0, 0)
    love.graphics.rectangle("fill", 110, 100, 4, 4)  -- Red square

    love.graphics.setColor(1, 0.5, 1)
    love.graphics.rectangle("fill", 120, 100, 4, 4)  -- Pink square

    love.graphics.setColor(0, 0.5, 1)
    love.graphics.circle("fill", 142, 102, 4)  -- Blue circle (target)

    -- === END GAME RENDERING ===

    -- Finish drawing and scale to screen
    Renderer:finishDrawing()

    -- UI overlays (drawn at full window resolution)
    drawDebugOverlay()
end

function drawGradientBackground()
    -- Draw vertical gradient from cyan to blue
    -- Simple approach: draw horizontal lines with interpolated colors

    local colorTop = {0, 0.85, 0.85}     -- Cyan
    local colorBottom = {0, 0, 1}         -- Blue

    for y = 0, GAME_HEIGHT do
        local t = y / GAME_HEIGHT  -- 0 to 1

        local r = colorTop[1] + (colorBottom[1] - colorTop[1]) * t
        local g = colorTop[2] + (colorBottom[2] - colorTop[2]) * t
        local b = colorTop[3] + (colorBottom[3] - colorTop[3]) * t

        love.graphics.setColor(r, g, b)
        love.graphics.line(0, y, GAME_WIDTH, y)
    end
end

function drawDebugOverlay()
    -- Draw at full window resolution (not affected by canvas)
    if DEBUG then
        love.graphics.setColor(0, 1, 0)
        local stats = love.graphics.getStats()
        love.graphics.print("FPS: " .. love.timer.getFPS(), 10, 10)
        love.graphics.print("Draw Calls: " .. stats.drawcalls, 10, 25)
    end
end

function love.keypressed(key)
    -- ESC to quit
    if key == "escape" then
        love.event.quit()
    end

    -- F1 to toggle debug
    if key == "f1" then
        DEBUG = not DEBUG
    end
end

function love.resize(w, h)
    -- Handle window resize (if we enable it later)
    Renderer:resize(w, h)
end
```

**Key Changes:**
- Require renderer system
- Call `Renderer:startDrawing()` before game rendering
- All game drawing happens at 320x240 scale
- Call `Renderer:finishDrawing()` to scale to screen
- Added gradient background function
- Added test shapes (4x4 squares, circle)
- F1 toggles debug overlay

## Testing

### 1. Run the Game

```bash
love .
```

### 2. Visual Verification

**You should see:**
- Window at 1280x720
- Gradient background (cyan at top → blue at bottom)
- White text in top-left
- Three 4x4 squares: white, red, pink
- One blue circle
- All graphics crisp and pixel-perfect (no blur)
- FPS counter in top-left (green text)

### 3. Test Debug Toggle

Press F1 → Debug overlay disappears
Press F1 again → Debug overlay returns

### 4. Verify Pixel-Perfect Rendering

Zoom in closely (take screenshot and zoom in):
- Squares should be exactly 4x4 pixels (scaled to 16x16 on screen at 4x scale)
- No blurry edges
- Clean, sharp pixels
- No anti-aliasing

### 5. Check Console Output

Should show:
```
=================================
Egg Drop Game - Starting...
Love2D Version: 11.5.0
=================================
Renderer initialized:
  Game resolution: 320x240
  Window size: 1280x720
  Scale: 4x
  Letterbox offset: 0, 60
```

**Note:** Letterbox offset will be (0, 60) because:
- 320x240 at 4x scale = 1280x960
- 1280x720 window is narrower vertically
- So we scale to fit width (4x) and add 60px black bars top/bottom

Actually, let me recalculate:
- 1280 / 320 = 4 (horizontal scale)
- 720 / 240 = 3 (vertical scale)
- Use smaller (3x) to fit both dimensions
- 320x3 = 960, 240x3 = 720
- Offset X = (1280 - 960) / 2 = 160
- Offset Y = (720 - 720) / 2 = 0

So letterbox should be: `160, 0` (black bars on left/right)

### 6. Verify Coordinate Systems

The test shapes should appear at specific positions:
- Squares at y=100 (1/3 down the screen)
- Positioned near left side
- Circle slightly to the right

## Common Issues

### Issue: Blurry graphics

**Cause:** Filtering not set to "nearest"

**Fix:**
- Verify `love.graphics.setDefaultFilter("nearest", "nearest")` in love.load()
- Verify `canvas:setFilter("nearest", "nearest")` in renderer:init()

### Issue: Wrong scale or positioning

**Cause:** Window size doesn't match conf.lua

**Fix:** Check that conf.lua has width=1280, height=720

### Issue: Gradient not showing

**Cause:** Gradient drawn after shapes, covering them

**Fix:** Ensure `drawGradientBackground()` is called FIRST in love.draw()

### Issue: Black screen

**Cause:** Canvas not being drawn to screen

**Fix:** Verify `Renderer:finishDrawing()` is called after all game rendering

## Next Steps

Once rendering pipeline is working:
- Proceed to [03-dotmatrix-shader.md](03-dotmatrix-shader.md)
- This will add the Game Boy style screen effect

## Notes

- All game code now works in 320x240 coordinate space
- Canvas automatically scales to window
- Integer scaling ensures pixel-perfect rendering
- Letterboxing adds black bars if aspect ratio doesn't match
- Debug overlay draws at full window resolution (not scaled)

## Performance

- Single canvas draw call per frame
- Minimal overhead
- Should easily maintain 60 FPS
- Draw calls shown in debug overlay

## Future Enhancements

- Support window resizing (currently disabled)
- Add integer scaling enforcement option
- Fullscreen support
- Multiple canvas layers (parallax, etc.)

## Checklist

- [ ] src/systems/renderer.lua created
- [ ] main.lua updated with renderer
- [ ] Game runs without errors
- [ ] Gradient background displays
- [ ] Test shapes render crisp and pixel-perfect
- [ ] 4x4 squares are exactly 4 pixels (at game res)
- [ ] No blurry edges or anti-aliasing
- [ ] Debug overlay toggles with F1
- [ ] Console shows correct scale and offset
- [ ] FPS counter shows 60 FPS

## Estimated Time

30-45 minutes
