# Step 12: UI System

## Goal

Create the retro UI panels (left: egg counter, right: prize/level info) matching the Nintendo Land aesthetic.

## Dependencies

- **Step 09**: Level system complete

## Files to Create/Modify

### Create
- `src/systems/ui.lua` - UI rendering system

### Modify
- `main.lua` - Draw UI panels

## UI Elements

**Left Panel:**
- Egg count icon
- Eggs dropped counter
- Score (optional)

**Right Panel:**
- Prize icon
- Level number
- "DROP" button visual

**Center:**
- Decorative border around game area
- Title at top

## Visual Style

- Cyan panel backgrounds
- White text (pixel font)
- Coin/egg icon sprite
- Prize box sprite
- Clean retro layout

## Testing Checklist

- [ ] Left panel displays
- [ ] Right panel displays
- [ ] Border around game area
- [ ] Counter updates correctly
- [ ] Visual style matches screenshot
- [ ] Text readable

Next: [13-game-loop.md](13-game-loop.md)
