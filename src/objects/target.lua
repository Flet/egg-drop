-- Target circles
-- Blue circles that turn orange when hit by eggs

local Target = {}
Target.__index = Target

function Target.new(x, y)
    local self = setmetatable({}, Target)

    self.x = x
    self.y = y
    self.radius = 4  -- 8px diameter

    -- State
    self.hit = false
    self.animating = false
    self.animationTime = 0
    self.animationDuration = 0.3

    -- Colors
    self.colorBlue = {0, 0.5, 1}      -- Unhit
    self.colorOrange = {1, 0.65, 0}   -- Hit
    self.borderColor = {1, 1, 1}      -- White border

    return self
end

function Target:update(dt)
    if self.animating then
        self.animationTime = self.animationTime + dt
        if self.animationTime >= self.animationDuration then
            self.animating = false
            self.hit = true
        end
    end
end

function Target:draw()
    local cx = self.x
    local cy = self.y

    -- Determine color
    local color = self.colorBlue
    if self.hit then
        color = self.colorOrange
    elseif self.animating then
        -- Pulse between blue and orange during animation
        local t = (math.sin(self.animationTime * 25) + 1) / 2
        color = {
            self.colorBlue[1] + (self.colorOrange[1] - self.colorBlue[1]) * t,
            self.colorBlue[2] + (self.colorOrange[2] - self.colorBlue[2]) * t,
            self.colorBlue[3] + (self.colorOrange[3] - self.colorBlue[3]) * t
        }
    end

    -- Draw filled circle
    love.graphics.setColor(color)
    love.graphics.circle("fill", cx, cy, self.radius)

    -- Draw white border
    love.graphics.setColor(self.borderColor)
    love.graphics.circle("line", cx, cy, self.radius)
end

function Target:checkCollision(egg)
    local ex, ey = egg:getPosition()
    local eRadius = egg:getRadius()

    local dx = ex - self.x
    local dy = ey - self.y
    local distance = math.sqrt(dx * dx + dy * dy)

    return distance < (self.radius + eRadius)
end

function Target:onHit()
    if not self.hit and not self.animating then
        self.animating = true
        self.animationTime = 0
    end
end

function Target:isHit()
    return self.hit
end

-- Static functions for collections
function Target.updateAll(targets, dt)
    for _, target in ipairs(targets) do
        target:update(dt)
    end
end

function Target.drawAll(targets)
    for _, target in ipairs(targets) do
        target:draw()
    end
end

function Target.checkAllCollisions(targets, egg)
    for _, target in ipairs(targets) do
        if target:checkCollision(egg) then
            target:onHit()
        end
    end
end

function Target.allHit(targets)
    for _, target in ipairs(targets) do
        if not target:isHit() then
            return false
        end
    end
    return #targets > 0
end

function Target.countHit(targets)
    local count = 0
    for _, target in ipairs(targets) do
        if target:isHit() then
            count = count + 1
        end
    end
    return count
end

return Target
