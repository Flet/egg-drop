-- Level 2: The Funnel
-- Eggs funnel toward center using angled walls

return {
    objects = {
        targets = {
            {x = 105, y = 50},   -- Top left
            {x = 215, y = 50},   -- Top right
            {x = 145, y = 180},  -- Center left
            {x = 175, y = 180},  -- Center right
        },

        pegs = {
            -- Top bounce pegs
            {type = "round", x = 85, y = 70},
            {type = "round", x = 235, y = 70},

            -- Center bounce pegs (round - indestructible)
            {type = "round", x = 105, y = 160},
            {type = "round", x = 215, y = 160},
        },

        walls = {
            -- Left funnel wall (diagonal from top-left to center)
            {x1 = 50, y1 = 60, x2 = 120, y2 = 170},

            -- Right funnel wall (diagonal from top-right to center)
            {x1 = 270, y1 = 60, x2 = 200, y2 = 170},

            -- Bottom left barrier (angled)
            {x1 = 50, y1 = 190, x2 = 130, y2 = 210},

            -- Bottom right barrier (angled)
            {x1 = 270, y1 = 190, x2 = 190, y2 = 210},

            -- Center vertical divider
            {x1 = 160, y1 = 120, x2 = 160, y2 = 200},
        }
    },

    config = {
        name = "Level 2: The Funnel",
        bird_speed = 70,
        gravity = 200,
        par_eggs = 20
    }
}
