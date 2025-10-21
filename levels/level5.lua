-- Level 5: The Gauntlet
-- Precision required to navigate through narrow passages

return {
    objects = {
        targets = {
            {x = 150, y = 50},   -- Top center
            {x = 150, y = 220},  -- Bottom center
        },

        pegs = {
            -- Top left barrier
            {type = "square", x = 50, y = 66},
            {type = "square", x = 58, y = 66},
            {type = "square", x = 66, y = 66},

            -- Top right barrier
            {type = "square", x = 238, y = 66},
            {type = "square", x = 246, y = 66},
            {type = "square", x = 254, y = 66},

            -- Top round pegs
            {type = "round", x = 98, y = 66},
            {type = "round", x = 154, y = 66},
            {type = "round", x = 210, y = 66},

            -- Middle left barrier
            {type = "square", x = 74, y = 82},
            {type = "square", x = 82, y = 82},
            {type = "square", x = 90, y = 82},

            -- Middle right barrier
            {type = "square", x = 214, y = 82},
            {type = "square", x = 222, y = 82},
            {type = "square", x = 230, y = 82},

            -- Center round pegs
            {type = "round", x = 105, y = 98},
            {type = "round", x = 178, y = 98},

            -- Bottom left barrier
            {type = "square", x = 50, y = 146},
            {type = "square", x = 58, y = 146},
            {type = "square", x = 66, y = 146},

            -- Bottom right barrier
            {type = "square", x = 238, y = 146},
            {type = "square", x = 246, y = 146},
            {type = "square", x = 254, y = 146},

            -- Bottom round pegs
            {type = "round", x = 98, y = 146},
            {type = "round", x = 154, y = 146},
            {type = "round", x = 210, y = 146},
        }
    },

    config = {
        name = "Level 5: The Gauntlet",
        bird_speed = 55,
        gravity = 180,
        par_eggs = 25
    }
}
