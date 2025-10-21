# Step 06: Peg System

## Goal

Implement an extensible peg type system with square pegs (destructible, 3-hit) and round pegs (indestructible). Eggs bounce off pegs realistically.

## Dependencies

- **Step 05**: Egg physics complete
- **Step 02**: Rendering and helpers

## Files to Create/Modify

### Create
- `src/objects/peg.lua` - Base peg class with type system
- `src/systems/pegs.lua` - Peg type registry and factory

### Modify
- `main.lua` - Create test pegs, handle peg-egg collisions

## Implementation

Create complete peg system documentation at `src/objects/peg.lua` and `src/systems/pegs.lua`.

See full implementation details in file.

## Key Features

- **Square Pegs**: 4x4 pixels, White→Pink→Red→Destroyed
- **Round Pegs**: 12px diameter, indestructible
- Extensible type system for future peg variants
- Collision detection with eggs
- State management (hits, colors)

## Testing Checklist

- [ ] Square pegs change color on hit (white→pink→red)
- [ ] Square pegs disappear after 3 hits
- [ ] Round pegs never disappear
- [ ] Eggs bounce off pegs correctly
- [ ] Bounce angles look natural
- [ ] Can have multiple pegs simultaneously

Next: [07-collision-detection.md](07-collision-detection.md)
