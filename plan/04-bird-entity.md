# Step 04: Bird Entity

## Goal

Create the bird entity that moves horizontally at the top of the screen and spawns eggs when the player presses spacebar or clicks the mouse.

## Dependencies

- **Step 02**: Rendering pipeline complete
- Canvas and coordinate system established

## Files to Create/Modify

### Create
- `src/entities/bird.lua` - Bird entity class

### Modify
- `main.lua` - Initialize and update bird

## Implementation Details

### 1. Create Bird Entity

**File: `src/entities/bird.lua`**

```lua
-- Bird Entity
-- Moves horizontally at top of screen, drops eggs

local Bird = {}
Bird.__index = Bird

function Bird.new(x, y, gameWidth)
    local self = setmetatable({}, Bird)

    self.x = x
    self.y = y
    self.gameWidth = gameWidth

    -- Movement
    self.speed = 60  -- pixels per second
    self.direction = 1  -- 1 = right, -1 = left

    -- Visual
    self.width = 12
    self.height = 8
    self.color = {1, 1, 1}  -- White

    -- Egg dropping
    self.canDrop = true
    self.dropCooldown = 0
    self.dropCooldownTime = 0.1  -- Minimum time between drops

    return self
end

function Bird:update(dt)
    -- Move horizontally
    self.x = self.x + (self.speed * self.direction * dt)

    -- Bounce off edges (instant direction change)
    if self.direction == 1 and self.x >= self.gameWidth - self.width then
        self.x = self.gameWidth - self.width
        self.direction = -1
    elseif self.direction == -1 and self.x <= 0 then
        self.x = 0
        self.direction = 1
    end

    -- Update drop cooldown
    if self.dropCooldown > 0 then
        self.dropCooldown = self.dropCooldown - dt
        self.canDrop = self.dropCooldown <= 0
    end
end

function Bird:draw()
    love.graphics.setColor(self.color)

    -- Draw bird body (simple rectangle for now)
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)

    -- Draw beak (triangle pointing down) - drop indicator
    local beakX = self.x + self.width / 2
    local beakY = self.y + self.height
    love.graphics.setColor(1, 0.8, 0)  -- Yellow beak
    love.graphics.polygon("fill",
        beakX, beakY,
        beakX - 2, beakY + 3,
        beakX + 2, beakY + 3
    )

    -- Draw direction indicator (subtle)
    if self.direction == 1 then
        love.graphics.setColor(1, 1, 1, 0.5)
        love.graphics.circle("fill", self.x + self.width + 1, self.y + 4, 1)
    else
        love.graphics.setColor(1, 1, 1, 0.5)
        love.graphics.circle("fill", self.x - 1, self.y + 4, 1)
    end
end

function Bird:requestDrop()
    -- Returns drop position if drop is allowed
    if self.canDrop then
        self.dropCooldown = self.dropCooldownTime
        self.canDrop = false

        -- Return drop position (center-bottom of bird)
        return self.x + self.width / 2, self.y + self.height + 3
    end
    return nil, nil  -- Can't drop right now
end

function Bird:getDropPosition()
    -- Returns current drop position (for visual indicator)
    return self.x + self.width / 2, self.y + self.height
end

function Bird:setSpeed(speed)
    self.speed = speed
end

function Bird:getSpeed()
    return self.speed
end

return Bird
```

**Key Features:**
- Horizontal movement with constant speed
- Instant direction change at edges
- Drop cooldown prevents spam
- Simple rectangular bird shape with beak indicator
- Returns egg spawn position

### 2. Update main.lua

Add bird to the game:

**File: `main.lua`** - Add to existing code:

```lua
-- At top, add with other requires
local Bird = require("src.entities.bird")

-- Add global variable after Renderer
local bird

function love.load()
    -- ... existing code ...

    -- Initialize renderer
    Renderer:init()

    -- Store game dimensions for easy access
    GAME_WIDTH, GAME_HEIGHT = Renderer:getGameDimensions()

    -- Create bird at top-center of screen
    bird = Bird.new(GAME_WIDTH / 2 - 6, 20, GAME_WIDTH)
end

function love.update(dt)
    -- Update bird
    bird:update(dt)
end

function love.draw()
    -- Start drawing to low-res canvas
    Renderer:startDrawing()

    -- === GAME RENDERING (at 320x240) ===

    -- Draw gradient background (cyan to blue)
    drawGradientBackground()

    -- Draw bird
    bird:draw()

    -- Draw drop indicator line (shows where egg will drop)
    local dropX, dropY = bird:getDropPosition()
    love.graphics.setColor(1, 1, 1, 0.2)
    love.graphics.line(dropX, dropY, dropX, GAME_HEIGHT)

    -- Draw test content (can remove later)
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Egg Drop Game", 10, 10)
    love.graphics.print("Press SPACE to drop egg", 10, 210)
    love.graphics.print("Press ESC to quit", 10, 225)

    -- === END GAME RENDERING ===

    -- Finish drawing and scale to screen
    Renderer:finishDrawing()

    -- UI overlays (drawn at full window resolution)
    drawDebugOverlay()
end
```

### 3. Add Drop Input Handling

**File: `main.lua`** - Update keypressed and add mouse handler:

```lua
function love.keypressed(key)
    -- ESC to quit
    if key == "escape" then
        love.event.quit()
    end

    -- F1 to toggle debug
    if key == "f1" then
        DEBUG = not DEBUG
    end

    -- F2 to toggle shader
    if key == "f2" then
        Renderer:toggleShader()
    end

    -- SPACE to drop egg
    if key == "space" then
        local dropX, dropY = bird:requestDrop()
        if dropX then
            print("Egg dropped at: " .. dropX .. ", " .. dropY)
            -- TODO: Create egg entity (next step)
        end
    end
end

function love.mousepressed(x, y, button)
    -- Left click to drop egg
    if button == 1 then
        local dropX, dropY = bird:requestDrop()
        if dropX then
            print("Egg dropped at: " .. dropX .. ", " .. dropY)
            -- TODO: Create egg entity (next step)
        end
    end
end
```

### 4. Enhanced Debug Overlay

Update debug overlay to show bird info:

```lua
function drawDebugOverlay()
    if DEBUG then
        love.graphics.setColor(0, 1, 0)
        local stats = love.graphics.getStats()
        love.graphics.print("FPS: " .. love.timer.getFPS(), 10, 10)
        love.graphics.print("Draw Calls: " .. stats.drawcalls, 10, 25)
        love.graphics.print("Shader: " .. (Renderer:isShaderEnabled() and "ON" or "OFF") .. " (F2)", 10, 40)
        love.graphics.print("Bird X: " .. math.floor(bird.x), 10, 55)
        love.graphics.print("Bird Dir: " .. (bird.direction == 1 and "RIGHT" or "LEFT"), 10, 70)
    end
end
```

## Testing

### 1. Run the Game

```bash
love .
```

### 2. Visual Verification

**You should see:**
- White rectangular bird at top of screen
- Yellow beak/triangle pointing down
- Bird moving left-to-right
- Faint vertical line showing drop position
- Direction indicator (small circle on leading edge)

### 3. Test Movement

**Observe bird behavior:**
- Moves smoothly at constant speed
- Reaches right edge → instantly reverses
- Reaches left edge → instantly reverses
- No slowdown or acceleration
- No gaps or overlap at edges

### 4. Test Egg Dropping

**Press SPACE:**
- Console prints: "Egg dropped at: [x], [y]"
- Can drop multiple times rapidly (cooldown is short)

**Click mouse:**
- Same behavior as SPACE
- Console prints drop position

### 5. Verify Drop Position

- Printed X coordinate should be center of bird
- Should match the vertical indicator line
- Position updates as bird moves

### 6. Debug Overlay

Press F1 to view:
- Bird X position updates as it moves
- Direction switches between "RIGHT" and "LEFT"

## Common Issues

### Issue: Bird moves too fast/slow

**Cause:** Speed value needs adjustment

**Fix:** Edit `src/entities/bird.lua`:
```lua
self.speed = 60  -- Change this value
```
Try values between 40-100 for different feels

### Issue: Bird goes off screen

**Cause:** Edge detection not working

**Fix:** Verify gameWidth is passed correctly to Bird.new()

### Issue: Drop not working

**Cause:** Input handler not connected

**Fix:** Verify love.keypressed and love.mousepressed are in main.lua

### Issue: Drop spam (no cooldown)

**Cause:** Cooldown too short or not working

**Fix:** Increase dropCooldownTime in bird.lua:
```lua
self.dropCooldownTime = 0.2  -- Slower
```

## Bird Customization

### Speed

In `bird.lua`:
```lua
self.speed = 80  -- Faster
self.speed = 40  -- Slower
```

### Size

```lua
self.width = 16   -- Wider
self.height = 10  -- Taller
```

### Color

```lua
self.color = {0.8, 0.8, 1}  -- Light blue
self.color = {1, 0.5, 0.5}  -- Pink
```

### Drop Cooldown

```lua
self.dropCooldownTime = 0.05  -- Rapid fire
self.dropCooldownTime = 0.5   -- Slow deliberate drops
```

## Next Steps

Once bird is working:
- Proceed to [05-egg-physics.md](05-egg-physics.md)
- Implement egg entity with physics

## Notes

- Bird is very simple (rectangle + triangle)
- Can add sprite later if desired
- Drop position is center-bottom of bird
- Cooldown prevents accidental multiple drops
- Both keyboard and mouse input supported

## Future Enhancements

- Animated sprite
- Wing flapping animation
- Sound effect on drop
- Visual feedback when drop pressed
- Ability to slow/pause bird movement
- Different bird speeds per level

## Checklist

- [ ] src/entities/bird.lua created
- [ ] Bird appears at top of screen
- [ ] Bird moves left to right smoothly
- [ ] Bird reverses direction at edges
- [ ] Bird doesn't go off screen
- [ ] SPACE key drops egg (prints to console)
- [ ] Mouse click drops egg (prints to console)
- [ ] Drop position is center of bird
- [ ] Vertical indicator line shows drop location
- [ ] Debug overlay shows bird position and direction
- [ ] FPS remains at 60

## Estimated Time

30-40 minutes
