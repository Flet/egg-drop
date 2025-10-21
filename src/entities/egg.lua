-- Egg Entity
-- Physics-based falling egg with gravity and bouncing

local Egg = {}
Egg.__index = Egg

function Egg.new(x, y, playAreaX, playAreaWidth, gameHeight)
    local self = setmetatable({}, Egg)

    -- Position
    self.x = x
    self.y = y
    self.playAreaX = playAreaX
    self.playAreaWidth = playAreaWidth
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

    -- Bounce off play area side walls
    local leftEdge = self.playAreaX
    local rightEdge = self.playAreaX + self.playAreaWidth

    if self.x - self.radius < leftEdge then
        self.x = leftEdge + self.radius
        self.vx = math.abs(self.vx) * self.bounce
    elseif self.x + self.radius > rightEdge then
        self.x = rightEdge - self.radius
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
