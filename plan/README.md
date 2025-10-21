# Egg Drop Game - Implementation Plans

Complete step-by-step implementation guide for building the Love2D egg drop game.

## Overview

This directory contains detailed implementation plans broken down into 15 sequential steps, plus reference documentation. Each plan is self-contained and can be used to resume development with fresh context.

## Getting Started

1. Read [00-overview.md](00-overview.md) for complete project architecture
2. Follow plans in numerical order (01 through 15)
3. Reference docs in `reference/` as needed
4. Test each step before moving to next

## Implementation Plans

### Core Systems (Required)

| Step | Plan | Description | Est. Time |
|------|------|-------------|-----------|
| 00 | [Overview](00-overview.md) | Complete project architecture | 10 min read |
| 01 | [Core Setup](01-core-setup.md) | Project structure, conf.lua, main.lua | 15-30 min |
| 02 | [Rendering Pipeline](02-rendering-pipeline.md) | Canvas system, 320x240 scaling | 30-45 min |
| 03 | [Dot Matrix Shader](03-dotmatrix-shader.md) | Game Boy style visual effect | 20-30 min |
| 04 | [Bird Entity](04-bird-entity.md) | Horizontal moving bird, egg spawning | 30-40 min |
| 05 | [Egg Physics](05-egg-physics.md) | Gravity, bouncing, arcade physics | 40-50 min |
| 06 | [Peg System](06-peg-system.md) | Square & round pegs, extensible types | 45-60 min |
| 07 | [Collision Detection](07-collision-detection.md) | Centralized physics system | 40-50 min |
| 08 | [Targets](08-targets.md) | Blue→orange circles, animations | 30-40 min |
| 09 | [Level System](09-level-system.md) | Grid parser, level loading | 45-60 min |

### Enhanced Features (Optional Priority)

| Step | Plan | Description | Est. Time |
|------|------|-------------|-----------|
| 10 | [Walls](10-walls.md) | 1-pixel walls, line collision | 30-40 min |
| 11 | [Triangle Bumpers](11-triangle-bumpers.md) | Directional bouncing (can defer) | 40-50 min |
| 12 | [UI System](12-ui-system.md) | Retro panels, counters, borders | 45-60 min |
| 13 | [Game Loop](13-game-loop.md) | States, menus, progression | 60-90 min |

### Development Tools

| Step | Plan | Description | Est. Time |
|------|------|-------------|-----------|
| 14 | [Hot Reload](14-hot-reload.md) | Lurker integration, fast iteration | 15-20 min |
| 15 | [Polish & Extras](15-polish-and-extras.md) | Sounds, particles, juice | 2-4 hours |

## Reference Documentation

Located in `reference/`:

- [**Color Palette**](reference/color-palette.md) - All game colors with hex/rgb values
- [**Coordinate System**](reference/coordinate-system.md) - 320x240 coords, scaling, grid system
- [**Peg Specifications**](reference/peg-specifications.md) - Detailed peg types, physics, collision
- [**Level Format Examples**](reference/level-format-examples.md) - Complete level definitions, grid parsing

## Quick Reference

### Technologies

- **Engine**: Love2D 11.5+
- **Language**: Lua
- **Resolution**: 320x240 (scaled to 1280x720)
- **Libraries**: HUMP, Lurker
- **Style**: Retro pixel art with Game Boy shader

### Key Concepts

- **Canvas Rendering**: Draw at low-res, scale up
- **Arcade Physics**: Custom physics (not Box2D)
- **Grid Levels**: Visual string format for easy design
- **Extensible Pegs**: Type registry system
- **Hot Reload**: Live code updates during dev

### Controls

- **SPACE** / **Mouse Click**: Drop egg
- **ESC**: Quit (or pause in-game)
- **F1**: Toggle debug overlay
- **F2**: Toggle shader
- **F3**: Next level (debug)

### File Structure

```
lovely/
├── plan/              # These documentation files
├── conf.lua           # Love2D configuration
├── main.lua           # Entry point
├── lib/               # Third-party libraries
│   ├── lurker.lua
│   └── hump/
├── src/
│   ├── states/        # Game states
│   ├── entities/      # Bird, egg
│   ├── systems/       # Renderer, physics, level
│   ├── objects/       # Pegs, targets, walls
│   ├── shaders/       # GLSL shaders
│   └── utils/         # Helpers
├── levels/            # Level definitions
└── assets/            # Images, sounds, fonts
```

## Recommended Implementation Order

### MVP (Minimum Viable Product)

To get a playable game quickly:

1. **Steps 01-05**: Core + rendering + bird + eggs (2-3 hours)
2. **Steps 06-07**: Pegs + collision (1.5-2 hours)
3. **Steps 08-09**: Targets + levels (1.5-2 hours)

**Result**: Playable game with 2-3 test levels (~5-7 hours total)

### Complete Version

For full-featured game:

4. **Steps 10-12**: Walls + UI (2-3 hours)
5. **Step 13**: Game states and menus (1-2 hours)
6. **Steps 14-15**: Hot reload + polish (2-4 hours)

**Result**: Polished game ready for release (~10-16 hours total)

## Development Workflow

### Initial Setup (Steps 01-03)

```bash
cd lovely
love .  # Test after each step
```

### Iterative Development (Steps 04+)

1. Read plan markdown file
2. Implement features as described
3. Test using checklist in plan
4. Verify no errors before next step
5. Commit changes (optional)

### With Hot Reload (Step 14+)

1. Run game once: `love .`
2. Edit code in your editor
3. Save file
4. See changes instantly (no restart!)

## Tips for Success

### Before Starting

- Ensure Love2D 11.5+ installed
- Read overview.md completely
- Have text editor ready
- Console open for debug output

### During Development

- ✅ Complete each step fully before moving on
- ✅ Test using checklist in each plan
- ✅ Keep debug mode on (F1 overlay)
- ✅ Use console output for errors
- ✅ Save working versions frequently

### Common Pitfalls

- ❌ Skipping testing steps
- ❌ Not checking console for errors
- ❌ Forgetting to set nearest-neighbor filtering
- ❌ Using wrong coordinate system (screen vs game)
- ❌ Not cleaning up dead eggs (memory leak)

## Troubleshooting

### Game won't start

- Verify conf.lua and main.lua in root directory
- Check console for error messages
- Ensure running `love .` from correct folder

### Blurry graphics

- Check `love.graphics.setDefaultFilter("nearest", "nearest")`
- Verify canvas filter: `canvas:setFilter("nearest", "nearest")`

### Performance issues

- Press F1 to check FPS and draw calls
- Ensure dead eggs are removed from table
- Check for infinite loops in update functions

### Objects in wrong positions

- Verify using game coordinates (320x240), not screen coordinates
- Check coordinate conversion functions
- Use debug overlay to display positions

## Getting Help

If stuck on a step:

1. Re-read the plan carefully
2. Check "Common Issues" section in plan
3. Verify all dependencies completed
4. Check console for error messages
5. Review reference docs for specifications

## Next Steps After Completion

Once all 15 steps are complete:

### Level Design
- Create 10-20 levels with increasing difficulty
- Test level progression curve
- Get feedback from playtesters

### Content
- Add more peg types
- Create sound effects
- Design UI sprites/icons
- Add background music

### Polish
- Particle effects
- Screen transitions
- Better animations
- Juice and feel

### Release
- Package as .love file
- Test on different systems
- Create itch.io page
- Share with community!

## Estimated Total Time

- **MVP**: 5-7 hours (steps 01-09)
- **Complete**: 10-16 hours (all steps)
- **Polished**: +5-10 hours (content creation, level design)

## License & Credits

This implementation guide created for the Love2D egg drop game project inspired by Nintendo Land.

Libraries used:
- **Love2D**: https://love2d.org
- **HUMP**: https://github.com/vrld/hump
- **Lurker**: https://github.com/rxi/lurker

---

**Ready to start?** Begin with [01-core-setup.md](01-core-setup.md)!
