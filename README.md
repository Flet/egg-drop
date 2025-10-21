# Egg Drop - Love2D Game

A retro-styled egg drop puzzle game inspired by Nintendo Land's Coin Game. Drop eggs from a moving bird to hit all targets while bouncing off pegs.

## Features

- **Pixel-perfect retro rendering** at 320x240, scaled to 1280x720
- **Game Boy style shader** with dot matrix effect
- **5 unique levels** with increasing difficulty
- **Two peg types:**
  - Square pegs (destructible, 3 hits)
  - Round pegs (indestructible)
- **Level progression** with win detection
- **Hot reload** for rapid development
- **Arcade-style physics** with satisfying bouncing

## Controls

- **SPACE** or **Left Click** - Drop egg
- **F1** - Toggle debug overlay
- **F2** - Toggle shader effect
- **F3** - Skip to next level (debug)
- **ESC** - Quit game

## How to Play

1. The bird moves back and forth at the top of the screen
2. Press SPACE or click to drop eggs
3. Hit all blue target circles to turn them orange
4. Use pegs to bounce eggs toward targets
5. Complete all targets to progress to the next level
6. Win all 5 levels to beat the game!

## Running the Game

```bash
love .
```

Requires Love2D 11.5 or later.

## Development

The game supports hot-reloading with Lurker. Edit any `.lua` file and save - changes will be reflected instantly in the running game!

### Project Structure

```
lovely/
├── conf.lua           # Love2D configuration
├── main.lua           # Entry point
├── lib/               # Third-party libraries
│   └── lurker.lua    # Hot reload
├── src/
│   ├── entities/     # Game entities (bird, egg)
│   ├── objects/      # Reusable objects (peg, target)
│   ├── systems/      # Core systems (renderer, level, pegs)
│   ├── shaders/      # GLSL shaders
│   └── utils/        # Helper functions
├── levels/           # Level definitions
│   ├── level1.lua
│   ├── level2.lua
│   ├── level3.lua
│   ├── level4.lua
│   └── level5.lua
└── assets/           # Game assets (currently empty)
```

## Creating New Levels

Levels use a simple grid format. Create a new file in `levels/`:

```lua
return {
    grid = [[
........T.......T.......
.■..■..■..■..■..■..■..■.
........●.......●.......
........T.......T.......
    ]],

    config = {
        name = "My Level",
        bird_speed = 60,
        gravity = 200,
        par_eggs = 20
    }
}
```

**Grid Legend:**
- `T` = Target (blue circle)
- `■` or `S` = Square peg (destructible)
- `●` or `O` = Round peg (indestructible)
- `.` or space = Empty

Update `maxLevel` in main.lua to include new levels.

## Technical Details

- **Engine**: Love2D 11.5+
- **Language**: Lua
- **Resolution**: 320x240 (scaled to 1280x720)
- **FPS**: 60 (vsync enabled)
- **Physics**: Custom arcade-style (not Box2D)

## Credits

Inspired by Nintendo Land (Wii U) - Coin Game
Built with Love2D
Shader effects for retro aesthetic
