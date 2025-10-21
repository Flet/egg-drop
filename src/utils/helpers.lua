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
