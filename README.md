# Egg Drop - Love2D Game

A retro-styled egg drop puzzle game inspired by Nintendo Land's Coin Game. Drop eggs from a moving bird to hit all targets while bouncing off pegs.

## Features

- **Pixel-perfect retro rendering** at 320x240, scaled to 1280x720
- **Game Boy style shader** with dot matrix effect
- **5 unique levels** with increasing difficulty
- **Two peg types:**
  - Square pegs (destructible, 3 hits)
  - Round pegs (indestructible)
- **Dynamic sound effects** with pitch variation for natural audio variety
- **Level progression** with win detection
- **Hot reload** for rapid development
- **Arcade-style physics** with satisfying bouncing
- **Play online** - Playable in browser via GitHub Pages

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

### Desktop Version

```bash
love .
```

Requires Love2D 11.4 or later.

### Web Version

The game is also available to play in your browser! See [DEPLOY.md](DEPLOY.md) for deployment instructions.

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
│   ├── objects/      # Reusable objects (peg, target, wall)
│   ├── systems/      # Core systems (renderer, level, pegs, audio)
│   ├── shaders/      # GLSL shaders
│   └── utils/        # Helper functions
├── levels/           # Level definitions
│   ├── level1.lua
│   ├── level2.lua
│   ├── level3.lua
│   ├── level4.lua
│   └── level5.lua
└── assets/           # Game assets
    └── sounds/       # Audio files (.ogg format)
```

## Creating New Levels

Levels use pixel-perfect coordinate placement. Create a new file in `levels/`:

```lua
return {
    -- Play area is 240x240 pixels, starting at x=40
    -- Available area: x: 40-280, y: 0-240

    objects = {
        -- Targets (blue circles that turn orange when hit)
        targets = {
            {x = 100, y = 50},
            {x = 160, y = 50},
            {x = 220, y = 50},
        },

        -- Pegs (obstacles)
        pegs = {
            -- Square pegs (destructible: white -> pink -> red -> destroyed)
            {type = "square", x = 60, y = 90},
            {type = "square", x = 120, y = 90},

            -- Round pegs (indestructible bounce)
            {type = "round", x = 100, y = 130},
            {type = "round", x = 160, y = 130},
        },

        -- Walls (optional, thin line segments)
        walls = {
            {x1 = 50, y1 = 100, x2 = 200, y2 = 100},  -- Horizontal wall
        }
    },

    config = {
        name = "My Level",
        bird_speed = 60,      -- Speed of bird movement
        gravity = 200,        -- Gravity force on eggs
        par_eggs = 15         -- Target number of eggs (for rating)
    }
}
```

**Object Types:**
- **Targets**: Blue circles (radius 4px) that turn orange when hit by eggs
- **Square pegs**: 6x6px destructible blocks (3 hits to destroy)
- **Round pegs**: 6px radius indestructible circles
- **Walls**: Thin line segments eggs bounce off of

Update `maxLevel` in [main.lua](main.lua#L29) to include new levels.

## Sound Effects

The game includes dynamic audio with pitch variation:
- **pop.ogg** - Egg drop sound
- **bounce.ogg** - Circle peg collision
- **click.ogg** - Square peg collision
- **sweep.ogg** - Target hit
- **clack.ogg** - Wall collision

All sounds use `.ogg` format and include random pitch variation for natural variety.

## Building & Distribution

See [BUILD.md](BUILD.md) for instructions on creating distributable versions:
- `.love` files for Love2D users
- Platform-specific executables (Windows, macOS)
- Web builds for browser play

See [DEPLOY.md](DEPLOY.md) for GitHub Pages deployment.

## Technical Details

- **Engine**: Love2D 11.4+
- **Language**: Lua
- **Resolution**: 320x240 (scaled to 1280x720)
- **FPS**: 60 (vsync enabled)
- **Physics**: Custom arcade-style (not Box2D)
- **Audio**: OpenAL via Love2D with source pooling

## Credits

Inspired by Nintendo Land (Wii U) - Coin Game
Built with Love2D
Shader effects for retro aesthetic
Web support via love.js
