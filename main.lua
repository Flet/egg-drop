-- Egg Drop Game
-- Main entry point

-- Global configuration
DEBUG = true

-- Systems
local Renderer = require("src.systems.renderer")
local Audio = require("src.systems.audio")
local Bird = require("src.entities.bird")
local Egg = require("src.entities.egg")
local PegTypes = require("src.systems.pegs")
local Peg = require("src.objects.peg")
local Target = require("src.objects.target")
local Wall = require("src.objects.wall")
local Level = require("src.systems.level")

-- Hot reload (development)
local lurker = require("lib.lurker")

-- Game objects
local bird
local eggs = {}    -- Table to hold all active eggs
local pegs = {}    -- Table to hold all pegs
local targets = {} -- Table to hold all targets
local walls = {}   -- Table to hold all walls

-- Game state
local currentLevel = 1
local maxLevel = 5
local eggsDropped = 0
local levelName = ""

function love.load()
    -- Disable filtering for crisp pixel art
    love.graphics.setDefaultFilter("nearest", "nearest")

    print("=================================")
    print("Egg Drop Game - Starting...")
    print("Love2D Version: " .. love.getVersion())
    print("=================================")

    -- Initialize renderer
    Renderer:init()

    -- Initialize audio
    Audio:init()

    -- Store game dimensions for easy access
    GAME_WIDTH, GAME_HEIGHT = Renderer:getGameDimensions()

    -- Get play area dimensions
    PLAY_X, PLAY_Y, PLAY_SIZE, _ = Renderer:getPlayArea()
    PLAY_WIDTH = PLAY_SIZE
    PLAY_HEIGHT = PLAY_SIZE

    -- Create bird at top-center of PLAY AREA (not full screen)
    bird = Bird.new(PLAY_X + PLAY_WIDTH / 2 - 6, 20, PLAY_X, PLAY_WIDTH)

    -- Configure lurker
    lurker.quiet = false -- Show reload messages

    -- Load first level
    loadLevel(currentLevel)
end

function loadLevel(levelNum)
    -- Clear existing objects
    eggs = {}
    pegs = {}
    targets = {}
    walls = {}
    eggsDropped = 0

    -- Load level data
    local levelPath = "levels.level" .. levelNum
    local success, levelData = pcall(function()
        return Level.load(levelPath)
    end)

    if not success then
        print("ERROR: Failed to load level " .. levelNum)
        print(levelData)
        -- Fallback to empty level
        levelName = "Error Loading Level"
        return
    end

    -- Set level objects
    pegs = levelData.pegs
    targets = levelData.targets
    walls = levelData.walls or {} -- Walls are optional
    levelName = levelData.name

    -- Apply level config
    if levelData.config.bird_speed then
        bird:setSpeed(levelData.config.bird_speed)
    end

    print("========================================")
    print("Loaded: " .. levelName)
    print("Targets: " .. #targets .. " | Pegs: " .. #pegs .. " | Walls: " .. #walls)
    print("========================================")
end

function nextLevel()
    currentLevel = currentLevel + 1
    if currentLevel > maxLevel then
        print("========================================")
        print("GAME COMPLETE! You won!")
        print("Restarting from level 1...")
        print("========================================")
        currentLevel = 1
    end
    loadLevel(currentLevel)
end

function love.update(dt)
    -- Hot reload check
    lurker.update()

    -- Update bird
    bird:update(dt)

    -- Update targets
    Target.updateAll(targets, dt)

    -- Update all eggs
    for i = #eggs, 1, -1 do
        eggs[i]:update(dt)

        -- Check collisions with targets (eggs pass through)
        for _, target in ipairs(targets) do
            if target:checkCollision(eggs[i]) then
                local wasNewHit = target:onHit()
                if wasNewHit then
                    Audio:playSweepSound()
                end
            end
        end

        -- Check collisions with pegs (eggs bounce)
        for _, peg in ipairs(pegs) do
            if Peg.checkCollision(peg, eggs[i]) then
                Peg.handleCollision(peg, eggs[i])

                -- Play appropriate sound based on peg shape
                if peg.shape == "circle" then
                    Audio:playBounceSound()
                elseif peg.shape == "rectangle" then
                    Audio:playClickSound()
                end
            end
        end

        -- Check collisions with walls (eggs bounce)
        local wallCollision = Wall.checkAllCollisions(walls, eggs[i])
        if wallCollision then
            Audio:playClackSound()
        end

        -- Check collisions with other eggs (egg-to-egg bounce)
        for j = i + 1, #eggs do
            local egg1 = eggs[i]
            local egg2 = eggs[j]

            local x1, y1 = egg1:getPosition()
            local x2, y2 = egg2:getPosition()
            local r1 = egg1:getRadius()
            local r2 = egg2:getRadius()

            -- Check if eggs are colliding
            local dx = x2 - x1
            local dy = y2 - y1
            local distance = math.sqrt(dx * dx + dy * dy)

            if distance < (r1 + r2) and distance > 0 then
                -- Eggs are colliding - bounce them off each other
                egg1:bounceOffCircle(x2, y2, r2)
            end
        end

        -- Remove dead eggs
        if not eggs[i]:isAlive() then
            table.remove(eggs, i)
        end
    end

    -- Update pegs (remove destroyed ones)
    Peg.updateAll(pegs)

    -- Check win condition
    if Target.allHit(targets) then
        print("LEVEL COMPLETE! All targets hit!")
        print("Eggs used: " .. eggsDropped)
        nextLevel()
    end
end

function love.draw()
    -- Start drawing to low-res canvas
    Renderer:startDrawing()

    -- === GAME RENDERING (at 320x240) ===

    -- Draw gradient background (cyan to blue)
    drawGradientBackground()

    -- Draw UI panels (darker shade)
    love.graphics.setColor(0, 0.4, 0.4)                                          -- Darker cyan
    love.graphics.rectangle("fill", 0, 0, PLAY_X, GAME_HEIGHT)                   -- Left panel
    love.graphics.rectangle("fill", PLAY_X + PLAY_WIDTH, 0, PLAY_X, GAME_HEIGHT) -- Right panel

    -- Draw white border around play area
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("line", PLAY_X, PLAY_Y, PLAY_WIDTH, PLAY_HEIGHT)

    -- Draw all walls (before other objects)
    Wall.drawAll(walls)

    -- Draw all targets
    Target.drawAll(targets)

    -- Draw all pegs
    Peg.drawAll(pegs)

    -- Draw all eggs
    for _, egg in ipairs(eggs) do
        egg:draw()
    end

    -- Draw bird (on top of eggs)
    bird:draw()

    -- Draw drop indicator line (shows where egg will drop, only in play area)
    -- local dropX, dropY = bird:getDropPosition()
    -- love.graphics.setColor(1, 1, 1, 0.2)
    -- love.graphics.line(dropX, dropY, dropX, GAME_HEIGHT)

    -- Draw level info in left panel
    love.graphics.setColor(1, 1, 1)
    local hitTargets = Target.countHit(targets)
    love.graphics.print("Lvl " .. currentLevel .. "/" .. maxLevel, 5, 10)
    love.graphics.print("Tgt:", 5, 25)
    love.graphics.print(hitTargets .. "/" .. #targets, 5, 35)
    love.graphics.print("Eggs:", 5, 50)
    love.graphics.print(eggsDropped, 5, 60)

    -- === END GAME RENDERING ===

    -- Finish drawing and scale to screen
    Renderer:finishDrawing()

    -- UI overlays (drawn at full window resolution)
    drawDebugOverlay()
end

function drawGradientBackground()
    -- Draw vertical gradient from cyan to blue
    -- Simple approach: draw horizontal lines with interpolated colors

    local colorTop = { 0, 0.85, 0.85 } -- Cyan
    local colorBottom = { 0, 0, 1 }    -- Blue

    for y = 0, GAME_HEIGHT do
        local t = y / GAME_HEIGHT -- 0 to 1

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
        love.graphics.print("Level: " .. currentLevel .. "/" .. maxLevel .. " - " .. levelName, 10, 25)
        local hitTargets = Target.countHit(targets)
        love.graphics.print(
        "Targets: " .. hitTargets .. "/" .. #targets .. " | Pegs: " .. #pegs .. " | Walls: " .. #walls, 10, 40)
        love.graphics.print("Eggs Dropped: " .. eggsDropped .. " | Active: " .. #eggs, 10, 55)
        love.graphics.print("Shader: " .. (Renderer:isShaderEnabled() and "ON" or "OFF") .. " (F2)", 10, 70)
        love.graphics.print("F3: Next Level", 10, 85)
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
            local egg = Egg.new(dropX, dropY, PLAY_X, PLAY_WIDTH, GAME_HEIGHT)
            table.insert(eggs, egg)
            eggsDropped = eggsDropped + 1

            -- Play drop sound with pitch variation
            Audio:playDropSound()
        end
    end

    -- F3 to skip to next level (debug)
    if key == "f3" then
        print("Skipping to next level...")
        nextLevel()
    end
end

function love.mousepressed(_x, _y, button)
    -- Left click to drop egg
    if button == 1 then
        local dropX, dropY = bird:requestDrop()
        if dropX then
            -- Create new egg
            local egg = Egg.new(dropX, dropY, PLAY_X, PLAY_WIDTH, GAME_HEIGHT)
            table.insert(eggs, egg)
            eggsDropped = eggsDropped + 1

            -- Play drop sound with pitch variation
            Audio:playDropSound()
        end
    end
end

function love.resize(w, h)
    -- Handle window resize (if we enable it later)
    Renderer:resize(w, h)
end
