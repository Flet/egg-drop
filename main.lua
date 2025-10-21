-- Egg Drop Game
-- Main entry point

-- Global configuration
DEBUG = true

-- Systems
local Renderer = require("src.systems.renderer")
local Bird = require("src.entities.bird")
local Egg = require("src.entities.egg")

-- Game objects
local bird
local eggs = {}  -- Table to hold all active eggs

function love.load()
    -- Disable filtering for crisp pixel art
    love.graphics.setDefaultFilter("nearest", "nearest")

    print("=================================")
    print("Egg Drop Game - Starting...")
    print("Love2D Version: " .. love.getVersion())
    print("=================================")

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

    -- Draw gradient background (cyan to blue)
    drawGradientBackground()

    -- Draw all eggs
    for _, egg in ipairs(eggs) do
        egg:draw()
    end

    -- Draw bird (on top of eggs)
    bird:draw()

    -- Draw drop indicator line (shows where egg will drop)
    local dropX, dropY = bird:getDropPosition()
    love.graphics.setColor(1, 1, 1, 0.2)
    love.graphics.line(dropX, dropY, dropX, GAME_HEIGHT)

    -- Draw instructions
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("SPACE/CLICK to drop eggs", 10, 210)
    love.graphics.print("Eggs: " .. #eggs, 10, 225)

    -- === END GAME RENDERING ===

    -- Finish drawing and scale to screen
    Renderer:finishDrawing()

    -- UI overlays (drawn at full window resolution)
    drawDebugOverlay()
end

function drawGradientBackground()
    -- Draw vertical gradient from cyan to blue
    -- Simple approach: draw horizontal lines with interpolated colors

    local colorTop = {0, 0.85, 0.85}     -- Cyan
    local colorBottom = {0, 0, 1}         -- Blue

    for y = 0, GAME_HEIGHT do
        local t = y / GAME_HEIGHT  -- 0 to 1

        local r = colorTop[1] + (colorBottom[1] - colorTop[1]) * t
        local g = colorTop[2] + (colorBottom[2] - colorTop[2]) * t
        local b = colorTop[3] + (colorBottom[3] - colorTop[3]) * t

        love.graphics.setColor(r, g, b)
        love.graphics.line(0, y, GAME_WIDTH, y)
    end
end

function drawDebugOverlay()
    -- Draw at full window resolution (not affected by canvas)
    if DEBUG then
        love.graphics.setColor(0, 1, 0)
        local stats = love.graphics.getStats()
        love.graphics.print("FPS: " .. love.timer.getFPS(), 10, 10)
        love.graphics.print("Eggs: " .. #eggs, 10, 25)
        love.graphics.print("Draw Calls: " .. stats.drawcalls, 10, 40)
        love.graphics.print("Shader: " .. (Renderer:isShaderEnabled() and "ON" or "OFF") .. " (F2)", 10, 55)
        love.graphics.print("Bird X: " .. math.floor(bird.x), 10, 70)
    end
end

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
            -- Create new egg
            local egg = Egg.new(dropX, dropY, GAME_WIDTH, GAME_HEIGHT)
            table.insert(eggs, egg)
            print("Egg dropped! Total eggs: " .. #eggs)
        end
    end
end

function love.mousepressed(_x, _y, button)
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

function love.resize(w, h)
    -- Handle window resize (if we enable it later)
    Renderer:resize(w, h)
end
