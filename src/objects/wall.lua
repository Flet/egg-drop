-- Wall Object
-- Thin line segments that eggs bounce off (can be rotated)

local Wall = {}
Wall.__index = Wall

function Wall.new(x1, y1, x2, y2)
    local self = setmetatable({}, Wall)

    -- Line endpoints
    self.x1 = x1
    self.y1 = y1
    self.x2 = x2
    self.y2 = y2

    -- Calculate length and normal vector for collisions
    local dx = x2 - x1
    local dy = y2 - y1
    self.length = math.sqrt(dx * dx + dy * dy)

    -- Unit direction vector
    self.dirX = dx / self.length
    self.dirY = dy / self.length

    -- Unit normal vector (perpendicular to wall)
    self.normalX = -self.dirY
    self.normalY = self.dirX

    -- Visual
    self.color = {0.3, 0.3, 0.3}  -- Dark gray
    self.thickness = 1  -- Very thin

    return self
end

function Wall:draw()
    love.graphics.setColor(self.color)
    love.graphics.setLineWidth(self.thickness)
    love.graphics.line(self.x1, self.y1, self.x2, self.y2)
    love.graphics.setLineWidth(1)  -- Reset to default
end

-- Check collision with egg (line-circle collision)
function Wall.checkCollision(wall, egg)
    local ex, ey = egg:getPosition()
    local radius = egg:getRadius()

    -- Vector from line start to circle center
    local toCircleX = ex - wall.x1
    local toCircleY = ey - wall.y1

    -- Project circle center onto line (clamped to line segment)
    local projection = toCircleX * wall.dirX + toCircleY * wall.dirY
    projection = math.max(0, math.min(wall.length, projection))

    -- Closest point on line to circle
    local closestX = wall.x1 + projection * wall.dirX
    local closestY = wall.y1 + projection * wall.dirY

    -- Distance from closest point to circle center
    local dx = ex - closestX
    local dy = ey - closestY
    local distanceSquared = dx * dx + dy * dy

    return distanceSquared < (radius * radius)
end

-- Handle collision with egg
function Wall.handleCollision(wall, egg)
    local ex, ey = egg:getPosition()
    local evx, evy = egg.vx, egg.vy

    -- Vector from line start to circle center
    local toCircleX = ex - wall.x1
    local toCircleY = ey - wall.y1

    -- Project circle center onto line
    local projection = toCircleX * wall.dirX + toCircleY * wall.dirY
    projection = math.max(0, math.min(wall.length, projection))

    -- Closest point on line to circle
    local closestX = wall.x1 + projection * wall.dirX
    local closestY = wall.y1 + projection * wall.dirY

    -- Vector from closest point to egg center
    local dx = ex - closestX
    local dy = ey - closestY
    local distance = math.sqrt(dx * dx + dy * dy)

    if distance < 0.001 then
        -- Avoid division by zero, use wall normal
        dx = wall.normalX
        dy = wall.normalY
        distance = 1
    else
        dx = dx / distance
        dy = dy / distance
    end

    -- Check if egg is moving toward the wall
    local velocityDot = evx * dx + evy * dy
    if velocityDot >= 0 then
        -- Egg is moving away, no bounce needed
        return
    end

    -- Push egg out of wall
    local radius = egg:getRadius()
    local overlap = radius - distance
    if overlap > 0 then
        egg.x = egg.x + dx * (overlap + 0.5)  -- Small extra push to prevent sticking
        egg.y = egg.y + dy * (overlap + 0.5)
    end

    -- Reflect velocity
    local dot = evx * dx + evy * dy
    egg.vx = (evx - 2 * dot * dx) * egg.bounce * egg.friction
    egg.vy = (evy - 2 * dot * dy) * egg.bounce

    -- Add extra upward bias to prevent resting on walls
    if dy > 0.3 then  -- Wall is somewhat horizontal
        egg.vy = egg.vy * 0.8  -- Reduce downward velocity more aggressively
        if math.abs(egg.vy) < 10 then
            egg.vy = -20  -- Give a small upward kick if velocity is too low
        end
    end
end

-- Draw all walls
function Wall.drawAll(walls)
    for _, wall in ipairs(walls) do
        wall:draw()
    end
end

-- Check collision with all walls
function Wall.checkAllCollisions(walls, egg)
    for _, wall in ipairs(walls) do
        if Wall.checkCollision(wall, egg) then
            Wall.handleCollision(wall, egg)
        end
    end
end

return Wall
