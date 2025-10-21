# Egg Drop Game - Project Overview

## Game Concept

A retro-styled coin/egg drop puzzle game inspired by the Coin Game in Nintendo Land (Wii U). The player controls a bird that moves horizontally at the top of the screen, dropping eggs that fall with physics and bounce off pegs to hit target circles.

### Core Gameplay Loop

1. Bird moves back and forth at top of screen
2. Player presses spacebar or click the mouse to drop eggs
3. Eggs fall with gravity, bouncing off pegs and walls
4. Hit all blue target circles (turning them orange) to complete level
5. Progress to next level with new layout

## Technical Specifications

### Display & Resolution

- **Base Resolution**: 320x240 pixels (4:3 retro aspect ratio)
- **Window Size**: 1280x720 pixels (4x scale with letterboxing)
- **Rendering**: Low-res canvas scaled with nearest-neighbor filtering
- **Visual Effect**: Game Boy style dot matrix shader overlay
- **Color Palette**: Cyan/blue gradient background, white/pink/red pegs, blue/orange targets

### Game Area Layout

```
┌────────────────────────────────────────────────────────────┐
│  Left Panel    │    Game Play Area (bordered)   │  Right   │
│                │                                │  Panel   │
│  - Egg Count   │    [Bird at top]               │  - Prize │
│  - Score       │    [Pegs, Targets, Walls]      │  - Level │
│                │    [Eggs falling/bouncing]     │  - Info  │
└────────────────────────────────────────────────────────────┘
```

## Game Objects

### Bird (Egg Dropper)

- Position: Top of screen, horizontal movement
- Movement: Constant speed with instant direction change at edges
- Control: Spacebar/click to drop eggs
- Multiple eggs can be on screen simultaneously

### Eggs

- Physics: Gravity + arcade-style bouncing
- Behavior: Predictable bounces with upward bias
- Unlimited eggs (bonus for using fewer)
- Destroyed when exiting bottom of screen

### Peg Types (Extensible System)

#### 1. Square Pegs (Destructible)

- Size: 4x4 pixels
- States: White → Pink → Red → Destroyed (3 hits)
- Behavior: Bounces eggs, degrades with each hit

#### 2. Round Pegs (Indestructible)

- Size: 12 pixels diameter (~4x4 bounding box)
- Behavior: Always bounces eggs, never destroyed
- Color: White

#### 3. Triangle Bumpers (Future)

- Behavior: Directional bouncing based on orientation
- Various sizes and rotations

#### 4. Walls

- Size: 1 pixel wide
- Behavior: Eggs bounce or slide along them
- Static barriers

### Targets

- Size: 8 pixel diameter circles with white border
- States: Blue (unhit) → Animating (pulse/flash) → Orange (hit)
- Behavior: Eggs pass through (don't bounce)
- Win Condition: All targets must turn orange

## Architecture

### Project Structure

```
lovely/
├── conf.lua                    # Love2D configuration
├── main.lua                    # Entry point with hot-reload
├── lib/                        # Third-party libraries
│   ├── lurker.lua             # Hot-reload
│   └── hump/                  # Helper utilities
├── src/
│   ├── states/                # Game states
│   ├── entities/              # Game objects (bird, egg)
│   ├── systems/               # Core systems (physics, level, renderer)
│   ├── objects/               # Reusable objects (pegs, targets)
│   ├── shaders/               # GLSL shaders
│   └── utils/                 # Helper functions
├── levels/                     # Level definitions
└── assets/                     # Images, sounds, fonts
```

### Core Systems

#### 1. Rendering Pipeline

- Create 320x240 canvas
- Draw all game objects to canvas
- Apply dot matrix shader
- Scale canvas to window with letterboxing
- Nearest-neighbor filtering for crisp pixels

#### 2. Physics System

- Custom arcade-style physics (not Box2D)
- Gravity: Constant downward acceleration
- Bouncing: Predictable angles with upward bias
- Collision detection: Circle-circle, circle-rect, circle-line

#### 3. Level System

- Visual grid format for easy level design
- Grid parser converts characters to game objects
- Level progression tracking
- Configuration per level (bird speed, gravity, etc.)

#### 4. Peg Type Registry

- Extensible system for different peg types
- Each type defines: shape, size, behavior, rendering
- Easy to add new peg variants

#### 5. Hot Reload (Development)

- Lurker watches all .lua files
- Auto-reloads code on save
- Fast iteration cycle

## Implementation Order

1. **Core Setup** - Project structure, conf.lua, main.lua
2. **Rendering Pipeline** - Canvas system, scaling
3. **Dot Matrix Shader** - Game Boy style visual effect
4. **Bird Entity** - Movement and egg spawning
5. **Egg Physics** - Basic falling, gravity
6. **Peg System** - Square and round pegs with collision
7. **Collision Detection** - All collision types
8. **Targets** - Blue→orange with animation
9. **Level System** - Grid parser and level loading
10. **Walls** - 1-pixel wall collision
11. **Triangle Bumpers** - Directional bouncing
12. **UI System** - Panels, counters, visual polish
13. **Game Loop** - Win conditions, level progression
14. **Hot Reload** - Development workflow setup
15. **Polish** - Debug features, effects, particles

## Dependencies

### Libraries (Auto-downloaded)

- **Lurker** - Hot code reloading for development
- **HUMP** - Helper utilities collection:
  - `gamestate` - State management (menu, game, pause)
  - `timer` - Tweens, delays, time-based events
  - `class` - Simple OOP system
  - `vector` - 2D vector math
  - `camera` - Camera system (future use)

### Love2D Modules Required

- `love.graphics` - Rendering
- `love.window` - Window management
- `love.keyboard` - Input
- `love.timer` - Delta time
- `love.filesystem` - File loading
- `love.math` - Random, noise

## Color Palette

Based on Nintendo Land reference screenshot:

- **Background Gradient**: `#00D9D9` (cyan) → `#0000FF` (blue)
- **Border**: `#FFFFFF` (white) with `#FF00FF` (magenta) accent
- **Square Pegs**:
  - White: `#FFFFFF`
  - Pink: `#FF80FF`
  - Red: `#FF0000`
- **Round Pegs**: `#FFFFFF` (white)
- **Targets**:
  - Blue: `#0080FF`
  - Orange: `#FFA500`
  - Border: `#FFFFFF`
- **UI Panel Background**: `#00D9D9` (cyan/teal)
- **Text**: `#FFFFFF` (white)

## Development Workflow

1. Start Love2D game
2. Edit code in your editor
3. Save file
4. Lurker auto-reloads changes
5. See changes instantly (no restart needed)
6. Press F1 for debug overlay
7. Press F3 to skip to next level (testing)

## Key Design Principles

### Arcade Physics

- Predictable, not realistic
- Bounces tend upward for gameplay
- Deterministic (same drop ≈ same result)
- No complex physics engine overhead

### Extensible Architecture

- Easy to add new peg types
- Level format designed for rapid iteration
- Modular systems (renderer, physics, level separate)
- Clean separation of concerns

### Retro Aesthetic

- Low resolution with crisp pixel scaling
- Game Boy style dot matrix effect
- Limited color palette
- Pixel-perfect rendering

### Developer-Friendly

- Hot reload for instant feedback
- Visual grid level format
- Debug overlays and tools
- Clear code organization

## Next Steps

Follow the implementation plans in order:

- Start with [01-core-setup.md](01-core-setup.md)
- Each plan builds on previous ones
- Reference files in `plan/reference/` as needed
- Test each step before moving to next

## Future Enhancements (Post-MVP)

- Sound effects and music
- Particle effects on impacts
- Screen shake
- More peg types (multipliers, portals, etc.)
- Power-ups
- Menu system
- Save/load progress
- Leaderboards
- Level editor
- Custom physics tweaking per level
