# Step 13: Game Loop & States

## Goal

Implement complete game loop with HUMP.gamestate for menu, playing, win, game over states.

## Dependencies

- **Step 08**: Targets (win condition)
- **Step 09**: Levels
- **Step 12**: UI
- HUMP.gamestate library

## Files to Create/Modify

### Create
- `src/states/menu.lua` - Menu state
- `src/states/game.lua` - Playing state
- `src/states/win.lua` - Level complete state

### Modify
- `main.lua` - Use gamestate system

## Game States

**Menu:**
- Title screen
- Start button
- Instructions

**Playing:**
- Active gameplay
- All mechanics active
- Pause support

**Win:**
- Level complete message
- Stats (eggs used, time)
- Next level button

## State Flow

Menu → Playing → Win → Playing (next level)
              ↓
           Game Over (future)

## Testing Checklist

- [ ] States switch correctly
- [ ] Menu navigable
- [ ] Game plays correctly
- [ ] Win detection works
- [ ] Level progression works
- [ ] Can restart

Next: [14-hot-reload.md](14-hot-reload.md)
