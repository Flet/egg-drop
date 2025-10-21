# Step 05: Egg Physics

## Goal

Create egg entities with arcade-style physics (gravity, bouncing) that spawn from the bird and fall through the game area.

## Dependencies

- **Step 04**: Bird entity complete
- **Step 02**: Rendering pipeline complete

## Files to Create/Modify

### Create
- `src/entities/egg.lua` - Egg entity with physics
- `src/utils/helpers.lua` - Collision and math helpers

### Modify
- `main.lua` - Manage egg collection, spawn eggs from bird

## Implementation Details

### 1. Create Helper Utilities

**File: `src/utils/helpers.lua`**

```lua
-- Helper utility functions
-- Collision detection, math helpers, etc.

local Helpers = {}

-- Circle-circle collision
function Helpers.circleCollision(x1, y1, r1, x2, y2, r2)
    local dx = x2 - x1
    local dy = y2 - y1
    local distance = math.sqrt(dx * dx + dy * dy)
    return distance < (r1 + r2)
end

-- Circle-rectangle collision
function Helpers.circleRectCollision(cx, cy, radius, rx, ry, rw, rh)
    -- Find closest point on rectangle to circle center
    local closestX = math.max(rx, math.min(cx, rx + rw))
    local closestY = math.max(ry, math.min(cy, ry + rh))

    -- Calculate distance from closest point to circle center
    local dx = cx - closestX
    local dy = cy - closestY

    local distanceSquared = (dx * dx) + (dy * dy)
    return distanceSquared < (radius * radius)
end

-- Normalize vector
function Helpers.normalize(x, y)
    local length = math.sqrt(x * x + y * y)
    if length == 0 then
        return 0, 0
    end
    return x / length, y / length
end

-- Distance between two points
function Helpers.distance(x1, y1, x2, y2)
    local dx = x2 - x1
    local dy = y2 - y1
    return math.sqrt(dx * dx + dy * dy)
end

-- Clamp value between min and max
function Helpers.clamp(value, min, max)
    return math.max(min, math.min(max, value))
end

return Helpers
```

### 2. Create Egg Entity

**File: `src/entities/egg.lua`**

```lua
-- Egg Entity
-- Physics-based falling egg with gravity and bouncing

local Egg = {}
Egg.__index = Egg

function Egg.new(x, y, gameWidth, gameHeight)
    local self = setmetatable({}, Egg)

    -- Position
    self.x = x
    self.y = y
    self.gameWidth = gameWidth
    self.gameHeight = gameHeight

    -- Physics
    self.vx = 0          -- Horizontal velocity
    self.vy = 0          -- Vertical velocity
    self.gravity = 200   -- Pixels per second squared
    self.maxSpeed = 400  -- Terminal velocity

    -- Collision
    self.radius = 3      -- Circle collision radius

    -- Bouncing
    self.bounce = 0.7    -- Bounce coefficient (0-1, lower = less bouncy)
    self.friction = 0.98 -- Horizontal friction per bounce

    -- Visual
    self.color = {1, 1, 0.8}  -- Off-white/cream

    -- State
    self.alive = true

    return self
end

function Egg:update(dt)
    -- Apply gravity
    self.vy = self.vy + self.gravity * dt

    -- Limit max falling speed
    self.vy = math.min(self.vy, self.maxSpeed)

    -- Apply velocity
    self.x = self.x + self.vx * dt
    self.y = self.y + self.vy * dt

    -- Check if egg left game area (bottom)
    if self.y - self.radius > self.gameHeight then
        self.alive = false
    end

    -- Bounce off side walls
    if self.x - self.radius < 0 then
        self.x = self.radius
        self.vx = math.abs(self.vx) * self.bounce
    elseif self.x + self.radius > self.gameWidth then
        self.x = self.gameWidth - self.radius
        self.vx = -math.abs(self.vx) * self.bounce
    end
end

function Egg:draw()
    if not self.alive then return end

    love.graphics.setColor(self.color)
    love.graphics.circle("fill", self.x, self.y, self.radius)

    -- Subtle highlight for 3D effect
    love.graphics.setColor(1, 1, 1, 0.5)
    love.graphics.circle("fill", self.x - 1, self.y - 1, 1)
end

function Egg:bounceOffCircle(cx, cy, radius)
    -- Calculate bounce direction (away from circle center)
    local dx = self.x - cx
    local dy = self.y - cy
    local distance = math.sqrt(dx * dx + dy * dy)

    if distance == 0 then
        -- Avoid division by zero
        dx, dy = 0, -1
        distance = 1
    end

    -- Normalize bounce direction
    local nx = dx / distance
    local ny = dy / distance

    -- Move egg outside of circle
    local overlap = (self.radius + radius) - distance
    self.x = self.x + nx * overlap
    self.y = self.y + ny * overlap

    -- Reflect velocity with upward bias (arcade-style)
    local dot = self.vx * nx + self.vy * ny
    self.vx = (self.vx - 2 * dot * nx) * self.bounce * self.friction
    self.vy = (self.vy - 2 * dot * ny) * self.bounce

    -- Arcade physics: add upward bias to bounces
    if self.vy > 0 then
        self.vy = self.vy * 0.85  -- Reduce downward velocity
    end
end

function Egg:bounceOffRect(rx, ry, rw, rh)
    -- Find closest point on rectangle
    local closestX = math.max(rx, math.min(self.x, rx + rw))
    local closestY = math.max(ry, math.min(self.y, ry + rh))

    -- Calculate bounce direction
    local dx = self.x - closestX
    local dy = self.y - closestY
    local distance = math.sqrt(dx * dx + dy * dy)

    if distance == 0 or distance > self.radius then
        return  -- No collision
    end

    -- Normalize
    local nx = dx / distance
    local ny = dy / distance

    -- Move egg outside rectangle
    local overlap = self.radius - distance
    self.x = self.x + nx * overlap
    self.y = self.y + ny * overlap

    -- Reflect velocity with arcade bias
    local dot = self.vx * nx + self.vy * ny
    self.vx = (self.vx - 2 * dot * nx) * self.bounce * self.friction
    self.vy = (self.vy - 2 * dot * ny) * self.bounce

    -- Upward bias
    if self.vy > 0 then
        self.vy = self.vy * 0.85
    end
end

function Egg:isAlive()
    return self.alive
end

function Egg:kill()
    self.alive = false
end

function Egg:getPosition()
    return self.x, self.y
end

function Egg:getRadius()
    return self.radius
end

return Egg
```

**Key Physics Features:**
- Gravity acceleration
- Terminal velocity (max fall speed)
- Bounce coefficient (energy loss)
- Upward bias in bounces (arcade-style)
- Horizontal friction on bounce
- Side wall bouncing
- Auto-destroy when leaving bottom

### 3. Update main.lua

Add egg spawning and management:

**File: `main.lua`** - Add to existing code:

```lua
-- At top with other requires
local Egg = require("src.entities.egg")

-- Add global variables
local bird
local eggs = {}  -- Table to hold all active eggs

function love.load()
    -- ... existing code ...
end

function love.update(dt)
    -- Update bird
    bird:update(dt)

    -- Update all eggs
    for i = #eggs, 1, -1 do
        eggs[i]:update(dt)

        -- Remove dead eggs
        if not eggs[i]:isAlive() then
            table.remove(eggs, i)
        end
    end
end

function love.draw()
    -- Start drawing to low-res canvas
    Renderer:startDrawing()

    -- === GAME RENDERING (at 320x240) ===

    -- Draw gradient background
    drawGradientBackground()

    -- Draw all eggs
    for _, egg in ipairs(eggs) do
        egg:draw()
    end

    -- Draw bird (on top of eggs)
    bird:draw()

    -- Draw drop indicator line
    local dropX, dropY = bird:getDropPosition()
    love.graphics.setColor(1, 1, 1, 0.2)
    love.graphics.line(dropX, dropY, dropX, GAME_HEIGHT)

    -- Draw instructions
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("SPACE/CLICK to drop eggs", 10, 210)
    love.graphics.print("Eggs: " .. #eggs, 10, 225)

    -- === END GAME RENDERING ===

    Renderer:finishDrawing()

    -- UI overlays
    drawDebugOverlay()
end

function love.keypressed(key)
    -- ... existing code ...

    -- SPACE to drop egg
    if key == "space" then
        local dropX, dropY = bird:requestDrop()
        if dropX then
            -- Create new egg
            local egg = Egg.new(dropX, dropY, GAME_WIDTH, GAME_HEIGHT)
            table.insert(eggs, egg)
            print("Egg dropped! Total eggs: " .. #eggs)
        end
    end
end

function love.mousepressed(x, y, button)
    -- Left click to drop egg
    if button == 1 then
        local dropX, dropY = bird:requestDrop()
        if dropX then
            -- Create new egg
            local egg = Egg.new(dropX, dropY, GAME_WIDTH, GAME_HEIGHT)
            table.insert(eggs, egg)
        end
    end
end
```

Update debug overlay:

```lua
function drawDebugOverlay()
    if DEBUG then
        love.graphics.setColor(0, 1, 0)
        local stats = love.graphics.getStats()
        love.graphics.print("FPS: " .. love.timer.getFPS(), 10, 10)
        love.graphics.print("Eggs: " .. #eggs, 10, 25)
        love.graphics.print("Draw Calls: " .. stats.drawcalls, 10, 40)
        love.graphics.print("Bird X: " .. math.floor(bird.x), 10, 55)
    end
end
```

## Testing

### 1. Run the Game

```bash
love .
```

### 2. Drop Eggs

**Press SPACE or CLICK:**
- Egg appears under bird
- Egg falls downward (accelerating)
- Egg disappears when reaching bottom
- Can drop multiple eggs rapidly

### 3. Verify Physics

**Observe egg behavior:**
- Accelerates downward (gravity)
- Falls faster and faster
- Eventually reaches max speed
- Bounces off left/right walls
- Slight horizontal movement on wall bounce

### 4. Test Multiple Eggs

- Drop many eggs rapidly
- All should fall independently
- Counter shows current egg count
- Eggs removed when leaving screen

### 5. Check Wall Bouncing

- Drop egg near left edge
- Should bounce off left wall
- Same for right wall
- Loses some velocity on bounce

### 6. Verify Debug Info

Press F1:
- Shows current egg count
- FPS should be 60
- Egg count increases/decreases correctly

## Common Issues

### Issue: Eggs fall too fast/slow

**Cause:** Gravity value needs adjustment

**Fix:** Edit `src/entities/egg.lua`:
```lua
self.gravity = 250  -- Faster
self.gravity = 150  -- Slower
```

### Issue: Eggs too bouncy/not bouncy enough

**Cause:** Bounce coefficient

**Fix:**
```lua
self.bounce = 0.9  -- Very bouncy
self.bounce = 0.5  -- Less bouncy
```

### Issue: Eggs don't disappear at bottom

**Cause:** Alive check not working

**Fix:** Verify egg removal loop in love.update()

### Issue: Memory leak (eggs keep increasing)

**Cause:** Dead eggs not being removed

**Fix:** Ensure egg removal happens in update loop

## Physics Tuning

### Gravity

```lua
self.gravity = 200  -- Default
self.gravity = 150  -- Floaty
self.gravity = 300  -- Heavy
```

### Bounce

```lua
self.bounce = 0.7   -- Default
self.bounce = 0.9   -- Super bouncy
self.bounce = 0.4   -- Minimal bounce
```

### Friction

```lua
self.friction = 0.98  -- Default (slight slowdown)
self.friction = 1.0   -- No friction
self.friction = 0.9   -- Heavy friction
```

### Upward Bias

In `bounceOffCircle` and `bounceOffRect`:
```lua
self.vy = self.vy * 0.85  -- Default
self.vy = self.vy * 0.7   -- Strong upward bias
self.vy = self.vy * 0.95  -- Minimal bias
```

## Next Steps

Once eggs are working with physics:
- Proceed to [06-peg-system.md](06-peg-system.md)
- Add pegs that eggs can bounce off

## Notes

- Eggs have simple circle physics
- Arcade-style means less realistic, more fun
- Upward bias prevents eggs getting stuck falling straight down
- Wall bouncing prevents eggs going off-screen horizontally
- Automatic cleanup when leaving bottom

## Future Enhancements

- Egg sprite instead of circle
- Rotation animation while falling
- Trail effect behind falling egg
- Sound effect on bounce
- Particles on wall hit

## Checklist

- [ ] src/entities/egg.lua created
- [ ] src/utils/helpers.lua created
- [ ] Eggs spawn from bird position
- [ ] Eggs fall with gravity (accelerating)
- [ ] Eggs reach terminal velocity
- [ ] Eggs bounce off side walls
- [ ] Eggs disappear at bottom
- [ ] Multiple eggs can exist simultaneously
- [ ] Egg count updates correctly
- [ ] No memory leaks (eggs get cleaned up)
- [ ] FPS remains at 60 with multiple eggs

## Estimated Time

40-50 minutes
