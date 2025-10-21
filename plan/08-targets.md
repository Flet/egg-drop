# Step 08: Targets

## Goal

Implement target circles (8px diameter) that change from blue to orange when hit by eggs. Include pulse/flash animation.

## Dependencies

- **Step 07**: Collision detection
- HUMP.timer for animations (download lib)

## Files to Create/Modify

### Create
- `src/objects/target.lua` - Target circle entity
- Download HUMP library to `lib/hump/`

### Modify
- `main.lua` - Add targets, check win condition

## Implementation

Target states:
- **Blue**: Unhit
- **Animating**: Pulse/flash effect (0.3s)
- **Orange**: Hit complete

Features:
- Eggs pass through (don't bounce)
- Hit detection via collision
- Animated color transition
- Win when all targets orange

## Testing Checklist

- [ ] Targets render as 8px circles
- [ ] Blue targets turn orange when hit
- [ ] Animation plays smoothly
- [ ] Eggs pass through targets
- [ ] Win detection works
- [ ] Can reset level

Next: [09-level-system.md](09-level-system.md)
