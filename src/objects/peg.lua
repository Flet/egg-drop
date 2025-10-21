-- Peg object
-- Handles rendering and collision for pegs

local PegTypes = require("src.systems.pegs")

local Peg = {}

-- Draw a single peg
function Peg.draw(peg)
    if peg.destroyed then
        return
    end

    local color = PegTypes.getColor(peg)
    love.graphics.setColor(color)

    if peg.shape == "rectangle" then
        -- Draw square peg
        love.graphics.rectangle("fill", peg.x, peg.y, peg.width, peg.height)
    elseif peg.shape == "circle" then
        -- Draw round peg (center the circle)
        local cx = peg.x + peg.radius
        local cy = peg.y + peg.radius
        love.graphics.circle("fill", cx, cy, peg.radius)
    end
end

-- Draw all pegs in a collection
function Peg.drawAll(pegs)
    for _, peg in ipairs(pegs) do
        Peg.draw(peg)
    end
end

-- Check collision with egg (returns true if collision)
function Peg.checkCollision(peg, egg)
    if peg.destroyed then
        return false
    end

    local ex, ey = egg:getPosition()
    local radius = egg:getRadius()

    if peg.shape == "rectangle" then
        -- Circle-rectangle collision
        local closestX = math.max(peg.x, math.min(ex, peg.x + peg.width))
        local closestY = math.max(peg.y, math.min(ey, peg.y + peg.height))

        local dx = ex - closestX
        local dy = ey - closestY
        local distanceSquared = (dx * dx) + (dy * dy)

        return distanceSquared < (radius * radius)

    elseif peg.shape == "circle" then
        -- Circle-circle collision
        local cx = peg.x + peg.radius
        local cy = peg.y + peg.radius
        local dx = ex - cx
        local dy = ey - cy
        local distance = math.sqrt(dx * dx + dy * dy)

        return distance < (radius + peg.radius)
    end

    return false
end

-- Handle collision response (bounce egg off peg)
function Peg.handleCollision(peg, egg)
    if peg.destroyed then
        return
    end

    if peg.shape == "rectangle" then
        -- Bounce off rectangle
        egg:bounceOffRect(peg.x, peg.y, peg.width, peg.height)
    elseif peg.shape == "circle" then
        -- Bounce off circle
        local cx = peg.x + peg.radius
        local cy = peg.y + peg.radius
        egg:bounceOffCircle(cx, cy, peg.radius)
    end

    -- Register hit on peg
    PegTypes.onHit(peg)
end

-- Update pegs (remove destroyed ones)
function Peg.updateAll(pegs)
    for i = #pegs, 1, -1 do
        if pegs[i].destroyed then
            table.remove(pegs, i)
        end
    end
end

return Peg
