-- Level loading and parsing system
-- Loads levels from files and parses grid layouts

local PegTypes = require("src.systems.pegs")
local Target = require("src.objects.target")

local Level = {}

-- Parse grid string into game objects
function Level.parseGrid(gridString, cellSize, offsetY)
    cellSize = cellSize or 8  -- Default 8px per cell
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
            local px = (x - 1) * cellSize
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

    -- Parse grid if it exists
    local objects = {targets = {}, pegs = {}}

    if levelData.grid then
        objects = Level.parseGrid(levelData.grid, levelData.cellSize, levelData.offsetY)
    end

    -- Add custom objects if defined
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
        config = levelData.config or {}
    }
end

return Level
