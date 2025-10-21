-- Level 1: Tutorial
-- Simple introduction to the game mechanics

return {
    -- Custom placement with pixel-perfect positioning
    -- Play area is 240x240, starting at x=40
    -- Available area: x: 40-280, y: 0-240

    objects = {
        -- Targets (blue circles that turn orange when hit)
        targets = {
            {x = 100, y = 50},
            {x = 160, y = 50},
            {x = 220, y = 50},
            {x = 100, y = 180},
            {x = 220, y = 180},
        },

        -- Square pegs (destructible: white -> pink -> red -> gone)
        pegs = {
            {type = "square", x = 60, y = 90},
            {type = "square", x = 90, y = 90},
            {type = "square", x = 120, y = 90},
            {type = "square", x = 150, y = 90},
            {type = "square", x = 180, y = 90},
            {type = "square", x = 210, y = 90},
            {type = "square", x = 240, y = 90},

            -- Round pegs (indestructible bounce)
            {type = "round", x = 100, y = 130},
            {type = "round", x = 160, y = 130},
            {type = "round", x = 220, y = 130},
        }
    },

    config = {
        name = "Level 1: Tutorial",
        bird_speed = 60,
        gravity = 200,
        par_eggs = 15
    }
}
