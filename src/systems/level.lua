-- Level loading and parsing system
-- Loads levels from files and parses grid layouts

local PegTypes = require("src.systems.pegs")
local Target = require("src.objects.target")
local Wall = require("src.objects.wall")

local Level = {}

-- Parse grid string into game objects
function Level.parseGrid(gridString, cellSize, offsetX, offsetY)
    cellSize = cellSize or 8  -- Default 8px per cell
    offsetX = offsetX or 40   -- Default horizontal offset to center in play area
    offsetY = offsetY or 40   -- Default vertical offset to push grid down from bird area

    local objects = {
        targets = {},
        pegs = {}
    }

    -- Split grid into lines
    local lines = {}
    for line in gridString:gmatch("[^\n]+") do
        -- Trim whitespace
        line = line:match("^%s*(.-)%s*$")
        if #line > 0 then
            table.insert(lines, line)
        end
    end

    -- Parse each character in grid
    for y, line in ipairs(lines) do
        for x = 1, #line do
            local char = line:sub(x, x)
            local px = (x - 1) * cellSize + offsetX
            local py = (y - 1) * cellSize + offsetY

            -- Target
            if char == "T" then
                table.insert(objects.targets, Target.new(px + cellSize/2, py + cellSize/2))

            -- Square peg
            elseif char == "■" or char == "S" then
                table.insert(objects.pegs, PegTypes.create("square", px + 2, py + 2))

            -- Round peg
            elseif char == "●" or char == "O" then
                -- For round pegs, store x,y as the top-left of bounding box
                table.insert(objects.pegs, PegTypes.create("round", px, py))

            -- Empty space (dot or space)
            elseif char == "." or char == " " then
                -- Do nothing
            end
        end
    end

    print("Grid parsed: " .. #objects.targets .. " targets, " .. #objects.pegs .. " pegs")
    return objects
end

-- Load level from file
function Level.load(levelPath)
    local success, levelData = pcall(function()
        return require(levelPath)
    end)

    if not success then
        error("Failed to load level: " .. levelPath .. "\n" .. tostring(levelData))
    end

    -- Initialize objects
    local objects = {targets = {}, pegs = {}, walls = {}}

    -- New format: direct objects definition (pixel-perfect)
    if levelData.objects then
        -- Load targets
        if levelData.objects.targets then
            for _, t in ipairs(levelData.objects.targets) do
                table.insert(objects.targets, Target.new(t.x, t.y))
            end
        end

        -- Load pegs
        if levelData.objects.pegs then
            for _, p in ipairs(levelData.objects.pegs) do
                table.insert(objects.pegs, PegTypes.create(p.type, p.x, p.y))
            end
        end

        -- Load walls (line segments with x1,y1,x2,y2)
        if levelData.objects.walls then
            for _, w in ipairs(levelData.objects.walls) do
                table.insert(objects.walls, Wall.new(w.x1, w.y1, w.x2, w.y2))
            end
        end
    end

    -- Legacy format: grid-based (for backward compatibility)
    if levelData.grid then
        local gridObjects = Level.parseGrid(levelData.grid, levelData.cellSize, levelData.offsetX, levelData.offsetY)
        -- Merge grid objects with any existing objects
        for _, target in ipairs(gridObjects.targets) do
            table.insert(objects.targets, target)
        end
        for _, peg in ipairs(gridObjects.pegs) do
            table.insert(objects.pegs, peg)
        end
    end

    -- Legacy format: custom objects (deprecated, use 'objects' instead)
    if levelData.custom then
        if levelData.custom.targets then
            for _, t in ipairs(levelData.custom.targets) do
                table.insert(objects.targets, Target.new(t.x, t.y))
            end
        end
        if levelData.custom.pegs then
            for _, p in ipairs(levelData.custom.pegs) do
                table.insert(objects.pegs, PegTypes.create(p.type, p.x, p.y))
            end
        end
    end

    -- Return level data
    return {
        name = levelData.config and levelData.config.name or "Untitled",
        targets = objects.targets,
        pegs = objects.pegs,
        walls = objects.walls,
        config = levelData.config or {}
    }
end

return Level
