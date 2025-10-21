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
