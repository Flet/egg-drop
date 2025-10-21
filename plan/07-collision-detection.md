# Step 07: Collision Detection

## Goal

Centralize all collision detection logic into a physics system. Handle egg collisions with pegs, targets, walls, and other objects.

## Dependencies

- **Step 05**: Egg physics
- **Step 06**: Peg system

## Files to Create/Modify

### Create
- `src/systems/physics.lua` - Centralized collision system

### Modify
- `main.lua` - Use physics system for collision handling

## Implementation

Physics system handles:
- Egg vs Peg collisions (both types)
- Egg vs Target collisions
- Egg vs Wall collisions
- Spatial optimization (only check nearby objects)

## Testing Checklist

- [ ] Eggs bounce off pegs correctly
- [ ] No missed collisions
- [ ] No double-hits on single frame
- [ ] Performance good with many eggs/pegs
- [ ] Collision detection accurate

Next: [08-targets.md](08-targets.md)
