-- Peg type registry and factory
-- Defines all peg types and their properties

local PegTypes = {}

-- Peg type definitions
PegTypes.types = {
    square = {
        shape = "rectangle",
        width = 4,
        height = 4,
        destructible = true,
        maxHits = 3,
        states = {"white", "pink", "red"},
        colors = {
            {1, 1, 1},      -- White (unhit)
            {1, 0.5, 1},    -- Pink (1 hit)
            {1, 0, 0}       -- Red (2 hits)
        },
        bounce = 0.7,
        friction = 0.98
    },

    round = {
        shape = "circle",
        radius = 6,
        destructible = false,
        color = {1, 1, 1},  -- White
        bounce = 0.7,
        friction = 0.98
    }
}

-- Factory function to create peg data
function PegTypes.create(pegType, x, y)
    local typeData = PegTypes.types[pegType]
    if not typeData then
        error("Unknown peg type: " .. tostring(pegType))
    end

    local peg = {
        type = pegType,
        x = x,
        y = y,
        hits = 0,
        destroyed = false
    }

    -- Copy type-specific properties
    for k, v in pairs(typeData) do
        if peg[k] == nil then
            peg[k] = v
        end
    end

    return peg
end

-- Get current color based on hits
function PegTypes.getColor(peg)
    if peg.type == "square" then
        local colorIndex = math.min(peg.hits + 1, #peg.colors)
        return peg.colors[colorIndex]
    elseif peg.type == "round" then
        return peg.color
    end
    return {1, 1, 1}  -- Default white
end

-- Check if peg should be destroyed
function PegTypes.shouldDestroy(peg)
    if not peg.destructible then
        return false
    end
    return peg.hits >= peg.maxHits
end

-- Handle peg being hit
function PegTypes.onHit(peg)
    if peg.destructible then
        peg.hits = peg.hits + 1
        if PegTypes.shouldDestroy(peg) then
            peg.destroyed = true
        end
    end
end

return PegTypes
