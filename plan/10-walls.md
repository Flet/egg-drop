# Step 10: Walls

## Goal

Add 1-pixel wide walls that eggs bounce or slide along. Support vertical, horizontal, and diagonal walls.

## Dependencies

- **Step 07**: Collision detection
- **Step 09**: Level system

## Files to Create/Modify

### Create
- `src/objects/wall.lua` - Wall entity

### Modify
- `src/systems/physics.lua` - Add line collision
- `levels/*.lua` - Add walls to levels

## Implementation

Wall types:
- Vertical (`|`)
- Horizontal (`-`)
- Custom (defined with start/end points)

Collision: Line-circle intersection math

## Testing Checklist

- [ ] Walls render as 1px lines
- [ ] Eggs bounce off walls
- [ ] Slide physics works
- [ ] Walls in levels work
- [ ] No pass-through bugs

Next: [11-triangle-bumpers.md](11-triangle-bumpers.md)
