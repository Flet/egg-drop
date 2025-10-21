-- Level 3: Bounce House
-- Lots of round pegs create chaotic bouncing patterns

return {
    objects = {
        targets = {
            {x = 105, y = 50},   -- Top left
            {x = 195, y = 50},   -- Top right
            {x = 105, y = 220},  -- Bottom left
            {x = 195, y = 220},  -- Bottom right
        },

        pegs = {
            -- Staggered round peg pattern (all indestructible)
            -- Row 1
            {type = "round", x = 58, y = 66},
            {type = "round", x = 114, y = 66},
            {type = "round", x = 170, y = 66},
            {type = "round", x = 226, y = 66},

            -- Row 2 (offset)
            {type = "round", x = 74, y = 82},
            {type = "round", x = 130, y = 82},
            {type = "round", x = 186, y = 82},
            {type = "round", x = 242, y = 82},

            -- Row 3
            {type = "round", x = 58, y = 98},
            {type = "round", x = 114, y = 98},
            {type = "round", x = 170, y = 98},
            {type = "round", x = 226, y = 98},

            -- Row 4 (offset)
            {type = "round", x = 74, y = 114},
            {type = "round", x = 130, y = 114},
            {type = "round", x = 186, y = 114},
            {type = "round", x = 242, y = 114},

            -- Row 5
            {type = "round", x = 58, y = 130},
            {type = "round", x = 114, y = 130},
            {type = "round", x = 170, y = 130},
            {type = "round", x = 226, y = 130},

            -- Row 6 (offset)
            {type = "round", x = 74, y = 146},
            {type = "round", x = 130, y = 146},
            {type = "round", x = 186, y = 146},
            {type = "round", x = 242, y = 146},

            -- Row 7
            {type = "round", x = 58, y = 162},
            {type = "round", x = 114, y = 162},
            {type = "round", x = 170, y = 162},
            {type = "round", x = 226, y = 162},

            -- Row 8 (offset)
            {type = "round", x = 74, y = 178},
            {type = "round", x = 130, y = 178},
            {type = "round", x = 186, y = 178},
            {type = "round", x = 242, y = 178},
        }
    },

    config = {
        name = "Level 3: Bounce House",
        bird_speed = 80,
        gravity = 220,
        par_eggs = 30
    }
}
