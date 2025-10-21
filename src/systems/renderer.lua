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

    -- Shader support
    self.shader = nil
    self.shaderEnabled = true

    print("Renderer initialized:")
    print("  Game resolution: " .. self.gameWidth .. "x" .. self.gameHeight)
    print("  Window size: " .. self.windowWidth .. "x" .. self.windowHeight)
    print("  Scale: " .. self.scale .. "x")
    print("  Letterbox offset: " .. self.offsetX .. ", " .. self.offsetY)

    -- Load shader
    self:loadShader()
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

    -- Apply shader if enabled (will be added in step 03)
    if self.shaderEnabled and self.shader then
        love.graphics.setShader(self.shader)
    end

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

    -- Reset shader
    love.graphics.setShader()
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

function Renderer:loadShader()
    -- Load dot matrix shader
    local success, result = pcall(function()
        return love.graphics.newShader("src/shaders/dotmatrix.glsl")
    end)

    if success then
        self.shader = result
        print("  Shader loaded successfully")
    else
        print("  Warning: Could not load shader - " .. tostring(result))
        self.shader = nil
    end
end

function Renderer:toggleShader()
    self.shaderEnabled = not self.shaderEnabled
    print("Shader " .. (self.shaderEnabled and "enabled" or "disabled"))
end

function Renderer:isShaderEnabled()
    return self.shaderEnabled and self.shader ~= nil
end

return Renderer
