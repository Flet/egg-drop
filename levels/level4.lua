-- Level 4: Destruction Derby
-- Dense destructible square peg walls

return {
    objects = {
        targets = {
            {x = 105, y = 50},   -- Top left
            {x = 220, y = 50},   -- Top right
            {x = 105, y = 220},  -- Bottom left
            {x = 220, y = 220},  -- Bottom right
        },

        pegs = {
            -- Top wall of square pegs (3 rows deep, 26 pegs wide)
            -- Row 1
            {type = "square", x = 50, y = 66}, {type = "square", x = 58, y = 66}, {type = "square", x = 66, y = 66}, {type = "square", x = 74, y = 66},
            {type = "square", x = 82, y = 66}, {type = "square", x = 90, y = 66}, {type = "square", x = 98, y = 66}, {type = "square", x = 106, y = 66},
            {type = "square", x = 114, y = 66}, {type = "square", x = 122, y = 66}, {type = "square", x = 130, y = 66}, {type = "square", x = 138, y = 66},
            {type = "square", x = 146, y = 66}, {type = "square", x = 154, y = 66}, {type = "square", x = 162, y = 66}, {type = "square", x = 170, y = 66},
            {type = "square", x = 178, y = 66}, {type = "square", x = 186, y = 66}, {type = "square", x = 194, y = 66}, {type = "square", x = 202, y = 66},
            {type = "square", x = 210, y = 66}, {type = "square", x = 218, y = 66}, {type = "square", x = 226, y = 66}, {type = "square", x = 234, y = 66},
            {type = "square", x = 242, y = 66}, {type = "square", x = 250, y = 66},

            -- Row 2
            {type = "square", x = 50, y = 74}, {type = "square", x = 58, y = 74}, {type = "square", x = 66, y = 74}, {type = "square", x = 74, y = 74},
            {type = "square", x = 82, y = 74}, {type = "square", x = 90, y = 74}, {type = "square", x = 98, y = 74}, {type = "square", x = 106, y = 74},
            {type = "square", x = 114, y = 74}, {type = "square", x = 122, y = 74}, {type = "square", x = 130, y = 74}, {type = "square", x = 138, y = 74},
            {type = "square", x = 146, y = 74}, {type = "square", x = 154, y = 74}, {type = "square", x = 162, y = 74}, {type = "square", x = 170, y = 74},
            {type = "square", x = 178, y = 74}, {type = "square", x = 186, y = 74}, {type = "square", x = 194, y = 74}, {type = "square", x = 202, y = 74},
            {type = "square", x = 210, y = 74}, {type = "square", x = 218, y = 74}, {type = "square", x = 226, y = 74}, {type = "square", x = 234, y = 74},
            {type = "square", x = 242, y = 74}, {type = "square", x = 250, y = 74},

            -- Row 3
            {type = "square", x = 50, y = 82}, {type = "square", x = 58, y = 82}, {type = "square", x = 66, y = 82}, {type = "square", x = 74, y = 82},
            {type = "square", x = 82, y = 82}, {type = "square", x = 90, y = 82}, {type = "square", x = 98, y = 82}, {type = "square", x = 106, y = 82},
            {type = "square", x = 114, y = 82}, {type = "square", x = 122, y = 82}, {type = "square", x = 130, y = 82}, {type = "square", x = 138, y = 82},
            {type = "square", x = 146, y = 82}, {type = "square", x = 154, y = 82}, {type = "square", x = 162, y = 82}, {type = "square", x = 170, y = 82},
            {type = "square", x = 178, y = 82}, {type = "square", x = 186, y = 82}, {type = "square", x = 194, y = 82}, {type = "square", x = 202, y = 82},
            {type = "square", x = 210, y = 82}, {type = "square", x = 218, y = 82}, {type = "square", x = 226, y = 82}, {type = "square", x = 234, y = 82},
            {type = "square", x = 242, y = 82}, {type = "square", x = 250, y = 82},

            -- Round pegs for bouncing (middle section)
            {type = "round", x = 105, y = 114},
            {type = "round", x = 195, y = 114},

            -- Bottom wall (1 row)
            {type = "square", x = 50, y = 146}, {type = "square", x = 58, y = 146}, {type = "square", x = 66, y = 146}, {type = "square", x = 74, y = 146},
            {type = "square", x = 82, y = 146}, {type = "square", x = 90, y = 146}, {type = "square", x = 98, y = 146}, {type = "square", x = 106, y = 146},
            {type = "square", x = 114, y = 146}, {type = "square", x = 122, y = 146}, {type = "square", x = 130, y = 146}, {type = "square", x = 138, y = 146},
            {type = "square", x = 146, y = 146}, {type = "square", x = 154, y = 146}, {type = "square", x = 162, y = 146}, {type = "square", x = 170, y = 146},
            {type = "square", x = 178, y = 146}, {type = "square", x = 186, y = 146}, {type = "square", x = 194, y = 146}, {type = "square", x = 202, y = 146},
            {type = "square", x = 210, y = 146}, {type = "square", x = 218, y = 146}, {type = "square", x = 226, y = 146}, {type = "square", x = 234, y = 146},
            {type = "square", x = 242, y = 146}, {type = "square", x = 250, y = 146},
        }
    },

    config = {
        name = "Level 4: Destruction Derby",
        bird_speed = 60,
        gravity = 200,
        par_eggs = 50
    }
}
