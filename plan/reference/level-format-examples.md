# Level Format Examples

Complete examples of level definitions using the hybrid grid + config format.

## Basic Level Structure

```lua
-- levels/level1.lua
return {
    -- Visual grid layout
    grid = [[
...grid string here...
    ]],

    -- Configuration
    config = {
        name = "Level 1",
        bird_speed = 60,
        gravity = 200,
        par_eggs = 20
    },

    -- Custom objects (optional)
    custom = {
        walls = {},
        triangles = {}
    }
}
```

## Grid Legend

```
T = Target (blue circle, 8px diameter)
■ = Square peg (4x4, destructible)
● = Round peg (12px diameter, indestructible)
△ = Triangle bumper up
▽ = Triangle bumper down
◁ = Triangle bumper left
▷ = Triangle bumper right
| = Wall vertical
- = Wall horizontal
. = Empty space
```

## Example 1: Tutorial Level

Simple first level introducing mechanics.

```lua
return {
    grid = [[
................................
........T.......T.......T.......
................................
................................
.■..■..■..■..■..■..■..■..■..■..
................................
........●.......●.......●.......
................................
........T.......T.......T.......
................................
]],

    config = {
        name = "Tutorial",
        bird_speed = 50,
        gravity = 180,
        par_eggs = 15
    }
}
```

**Design Notes:**
- 6 targets (2 rows of 3)
- Square pegs in horizontal line
- Round pegs offset below squares
- Gentle physics
- Wide spacing (easy)

## Example 2: The Funnel

Eggs funnel toward center targets.

```lua
return {
    grid = [[
................................
|...............................|
|..■........................■...|
|....■....................■.....|
|......■................■.......|
|........■............■.........|
|..........●..T..T..●...........|
|........■............■.........|
|......■................■.......|
|....■....................■.....|
|..■........................■...|
|...............................|
]],

    config = {
        name = "The Funnel",
        bird_speed = 70,
        gravity = 200,
        par_eggs = 25
    },

    custom = {
        walls = {
            {x1 = 0, y1 = 8, x2 = 0, y2 = 88},    -- Left wall
            {x1 = 319, y1 = 8, x2 = 319, y2 = 88}  -- Right wall
        }
    }
}
```

**Design Notes:**
- Walls on sides
- Diagonal square peg lines create funnel
- 2 targets at center bottom
- Round pegs guard targets
- Medium difficulty

## Example 3: Bounce House

Lots of round pegs create chaotic bouncing.

```lua
return {
    grid = [[
........T...........T...........
................................
..●.......●.......●.......●.....
................................
....●.......●.......●.......●...
................................
..●.......●.......●.......●.....
................................
....●.......●.......●.......●...
................................
........T...........T...........
]],

    config = {
        name = "Bounce House",
        bird_speed = 80,
        gravity = 220,
        par_eggs = 30
    }
}
```

**Design Notes:**
- 4 targets (corners)
- Checkerboard pattern of round pegs
- Eggs bounce unpredictably
- Fast bird, higher gravity
- Higher par (more challenging)

## Example 4: Destruction Derby

Focus on destroying square pegs to create paths.

```lua
return {
    grid = [[
........T...........T...........
................................
.■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■.
.■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■.
.■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■.
................................
........●...........●...........
................................
.■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■.
................................
........T...........T...........
]],

    config = {
        name = "Destruction Derby",
        bird_speed = 60,
        gravity = 200,
        par_eggs = 50
    }
}
```

**Design Notes:**
- Dense square peg walls
- Must destroy pegs to reach targets
- Round pegs act as pivots
- High par (destructive strategy)
- Rewards repeated hits

## Example 5: Triangle Maze

Using triangle bumpers to guide eggs.

```lua
return {
    grid = [[
........T.......................
................................
....▷...................◁.......
................................
........▽...........▽...........
................................
....●...................●.......
................................
........△...........△...........
................................
........T.......................
]],

    config = {
        name = "Triangle Maze",
        bird_speed = 65,
        gravity = 200,
        par_eggs = 20
    }
}
```

**Design Notes:**
- Triangle bumpers redirect eggs
- Right/left triangles push inward
- Up/down triangles bounce vertically
- Round pegs for additional bouncing
- Requires understanding directions

## Example 6: The Gauntlet

Long vertical challenge with obstacles.

```lua
return {
    grid = [[
................T...............
................................
.■■■.......●.......●.......■■■.
................................
....■■■.............■■■........
................................
........●.......●...............
................................
.■■■.......●.......●.......■■■.
................................
................T...............
]],

    config = {
        name = "The Gauntlet",
        bird_speed = 55,
        gravity = 180,
        par_eggs = 25
    }
}
```

**Design Notes:**
- 2 targets vertically aligned
- Alternating obstacles
- Narrow paths through barriers
- Slower physics for precision
- Requires careful aim

## Grid Parsing Logic

The grid parser converts each character to game objects:

```lua
function parseGrid(gridString)
    local objects = {
        targets = {},
        pegs = {},
        walls = {}
    }

    local lines = {}
    for line in gridString:gmatch("[^\n]+") do
        table.insert(lines, line)
    end

    local cellSize = 8  -- Each character = 8x8 pixel cell

    for y, line in ipairs(lines) do
        for x = 1, #line do
            local char = line:sub(x, x)
            local px = (x - 1) * cellSize
            local py = (y - 1) * cellSize

            if char == "T" then
                table.insert(objects.targets, {x = px + 4, y = py + 4})
            elseif char == "■" then
                table.insert(objects.pegs, {type = "square", x = px + 2, y = py + 2})
            elseif char == "●" then
                table.insert(objects.pegs, {type = "round", x = px + 4, y = py + 4})
            -- ... more types
            end
        end
    end

    return objects
end
```

## Grid Dimensions

**Recommended grid sizes:**

**40 columns × 30 rows** (8px cells)
- Total: 320x240 pixels
- Each cell: 8x8 pixels
- Easy to design
- Allows 4x4 pegs (half cell)
- Targets at 8px diameter (1 cell)

**32 columns × 24 rows** (10px cells)
- Total: 320x240 pixels
- Each cell: 10x10 pixels
- Roomier
- Less granular

**80 columns × 60 rows** (4px cells)
- Total: 320x240 pixels
- Each cell: 4x4 pixels (matches peg size)
- Most granular
- Harder to visualize

## Tips for Level Design

1. **Start Simple**: Few obstacles, clear paths
2. **Add Complexity**: More pegs, narrower gaps
3. **Test Par**: Play level, count eggs needed
4. **Balance**: Mix destructible and indestructible
5. **Visual Appeal**: Symmetry or interesting patterns
6. **Difficulty Curve**: Gradual increase across levels

## Configuration Parameters

```lua
config = {
    name = "Level Name",           -- Display name
    bird_speed = 60,               -- Pixels/second (40-100)
    gravity = 200,                 -- Acceleration (150-300)
    egg_bounce = 0.7,              -- Override default (0.5-0.9)
    par_eggs = 20,                 -- Eggs for par score
    prize = "star",                -- Prize icon
    background_color = "default",  -- Or custom gradient
    music = "theme1"               -- Music track (future)
}
```

## Custom Objects

For objects that need more than grid placement:

```lua
custom = {
    walls = {
        {x1 = 50, y1 = 50, x2 = 150, y2 = 50},  -- Horizontal wall
        {x1 = 100, y1 = 30, x2 = 100, y2 = 100}  -- Vertical wall
    },
    triangles = {
        {x = 100, y = 80, rotation = 45},  -- 45-degree triangle
        {x = 200, y = 120, rotation = 180}  -- Down-facing
    },
    special = {
        -- Future: portals, multipliers, etc.
    }
}
```

## Validation

Levels should validate:
- At least 1 target exists
- Targets reachable (not fully blocked)
- Grid dimensions match 320x240
- Bird speed reasonable (30-120)
- Gravity reasonable (100-400)

```lua
function validateLevel(level)
    assert(#level.objects.targets > 0, "Level must have at least one target")
    assert(level.config.bird_speed > 30, "Bird speed too low")
    assert(level.config.bird_speed < 120, "Bird speed too high")
    -- ... more validation
end
```
