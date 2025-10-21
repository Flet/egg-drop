# Coordinate System Reference

Understanding the 320x240 game coordinate system and scaling.

## Game Resolution

**Native Resolution**: 320 x 240 pixels (4:3 aspect ratio)

**Coordinate System:**
- Origin (0, 0) is top-left corner
- X increases rightward (0 to 320)
- Y increases downward (0 to 240)
- Game code works entirely in this coordinate space

## Screen Scaling

**Window Resolution**: 1280 x 720 pixels (16:9 aspect ratio)

**Scaling Calculation:**
```lua
scaleX = 1280 / 320 = 4
scaleY = 720 / 240 = 3
scale = min(4, 3) = 3  -- Use smaller to fit both dimensions
```

**Scaled Dimensions:**
- Game renders at: 320 × 3 = 960 width, 240 × 3 = 720 height
- Letterbox bars: (1280 - 960) / 2 = 160 pixels left and right

**Offset:**
```lua
offsetX = 160  -- Black bars on left/right
offsetY = 0    -- No vertical letterboxing
```

## Coordinate Conversion

### Screen to Game Coordinates

Convert mouse/screen coordinates to game coordinates:

```lua
function screenToGame(screenX, screenY)
    local gameX = (screenX - offsetX) / scale
    local gameY = (screenY - offsetY) / scale
    return gameX, gameY
end
```

**Example:**
- Mouse at screen (640, 360) → center of window
- Game coords: (640 - 160) / 3, (360 - 0) / 3 = (160, 120) → center of game

### Game to Screen Coordinates

Convert game coordinates to screen position:

```lua
function gameToScreen(gameX, gameY)
    local screenX = gameX * scale + offsetX
    local screenY = gameY * scale + offsetY
    return screenX, screenY
end
```

**Example:**
- Game pos (100, 50)
- Screen pos: 100 * 3 + 160, 50 * 3 + 0 = (460, 150)

## Grid System

For level design, useful to think in grid cells:

**Option 1: 4-pixel grid** (matches peg size)
- Grid cells: 320 / 4 = 80 columns, 240 / 4 = 60 rows
- Each cell is 4x4 pixels
- Easy to place 4x4 pegs

**Option 2: 8-pixel grid**
- Grid cells: 40 × 30
- Each cell is 8x8 pixels
- Room for larger objects

**Option 3: 16-pixel grid** (recommended for layout)
- Grid cells: 20 × 15
- Each cell is 16x16 pixels
- Good balance for level design

**Example with 8-pixel grid:**
```lua
-- Convert grid coords to pixel coords
function gridToPixel(gridX, gridY, cellSize)
    return gridX * cellSize, gridY * cellSize
end

-- Place peg at grid (10, 5) with 8px cells
local x, y = gridToPixel(10, 5, 8)  -- Returns (80, 40)
```

## Common Positions

### Vertical Zones (Y coordinates)

```
Y: 0-30     Top zone (bird area)
Y: 30-80    Upper game area
Y: 80-160   Middle game area
Y: 160-210  Lower game area
Y: 210-240  Bottom zone (edge before exit)
```

### Horizontal Zones (X coordinates)

```
X: 0-40     Left edge
X: 40-100   Left zone
X: 100-220  Center zone
X: 220-280  Right zone
X: 280-320  Right edge
```

### Key Positions

- **Screen Center**: (160, 120)
- **Bird Y**: 20 (typical)
- **Target Rows**: Y = 60, 100, 140, 180 (evenly spaced example)
- **Peg Rows**: Y = 50, 90, 130, 170 (offset from targets)

## Canvas Rendering

All game drawing happens to a 320x240 canvas:

```lua
-- Before drawing game
love.graphics.setCanvas(canvas)
love.graphics.clear()

-- Draw at game coords
love.graphics.rectangle("fill", 100, 50, 10, 10)  -- Uses game coords

-- After drawing game
love.graphics.setCanvas()

-- Draw scaled canvas to screen
love.graphics.draw(canvas, offsetX, offsetY, 0, scale, scale)
```

## Pixel Perfect Positioning

To ensure crisp rendering:

**Integer Coordinates:**
```lua
-- Good: Integer positions
x, y = 100, 50

-- Bad: Sub-pixel positions (can cause blur)
x, y = 100.5, 50.3
```

**Rounding:**
```lua
x = math.floor(x + 0.5)  -- Round to nearest integer
```

## Relative Positioning

Position objects relative to screen areas:

```lua
-- Center horizontally
x = GAME_WIDTH / 2 - objectWidth / 2

-- Bottom of screen with margin
y = GAME_HEIGHT - objectHeight - margin

-- Right align with margin
x = GAME_WIDTH - objectWidth - margin
```

## Collision Boundaries

Game boundaries for objects:

```lua
-- Keep object fully on screen
if x < 0 then x = 0 end
if x > GAME_WIDTH - width then x = GAME_WIDTH - width end
if y < 0 then y = 0 end
if y > GAME_HEIGHT - height then y = GAME_HEIGHT - height end
```

## Debug Visualization

Helpful debug overlays:

```lua
-- Draw grid overlay
function drawGrid(cellSize)
    love.graphics.setColor(1, 1, 1, 0.1)
    for x = 0, GAME_WIDTH, cellSize do
        love.graphics.line(x, 0, x, GAME_HEIGHT)
    end
    for y = 0, GAME_HEIGHT, cellSize do
        love.graphics.line(0, y, GAME_WIDTH, y)
    end
end

-- Draw center cross
love.graphics.line(GAME_WIDTH/2, 0, GAME_WIDTH/2, GAME_HEIGHT)
love.graphics.line(0, GAME_HEIGHT/2, GAME_WIDTH, GAME_HEIGHT/2)
```

## Summary

- All game logic uses 320x240 coordinates
- Renderer handles scaling to 1280x720 window
- Letterbox bars maintain aspect ratio
- Think in grid cells for level design
- Keep positions as integers for pixel-perfect rendering
