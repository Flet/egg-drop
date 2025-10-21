# Step 09: Level System

## Goal

Create a level loading system that parses visual grid layouts and spawns game objects. Support level progression.

## Dependencies

- **Step 06**: Pegs
- **Step 08**: Targets

## Files to Create/Modify

### Create
- `src/systems/level.lua` - Level loader and parser
- `levels/level1.lua` - First level definition
- `levels/level2.lua` - Second level

### Modify
- `main.lua` - Use level system, integrate with game state

## Level Format

```lua
return {
    grid = [[
        ........T.......T.......
        .■..■..●..■..■..........
        ........T.......T.......
    ]],
    config = {
        bird_speed = 60,
        gravity = 200,
        par_eggs = 20
    }
}
```

Legend:
- `T` = Target (blue circle)
- `■` = Square peg
- `●` = Round peg
- `.` = Empty

## Features

- Grid to object conversion
- Level progression
- Configuration per level
- Win condition checking
- Level reset

## Testing Checklist

- [ ] Level loads from file
- [ ] Grid parses correctly
- [ ] Objects spawn at right positions
- [ ] Level progression works
- [ ] Can complete level
- [ ] Can reset level

Next: [10-walls.md](10-walls.md)
