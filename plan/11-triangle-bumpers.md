# Step 11: Triangle Bumpers

## Goal

Add triangle-shaped bumpers with directional bouncing based on orientation. Future feature - can be deferred.

## Dependencies

- **Step 07**: Collision
- **Step 10**: Walls

## Files to Create/Modify

### Create
- `src/objects/triangle.lua` - Triangle bumper

### Modify
- `src/systems/physics.lua` - Triangle collision

## Implementation

Features:
- 4 orientations (up, down, left, right)
- Directional bounce (stronger in facing direction)
- Visual indicator for direction
- Grid symbol: `△` `▽` `◁` `▷`

## Notes

Can defer this step if focusing on core gameplay first.

Next: [12-ui-system.md](12-ui-system.md)
