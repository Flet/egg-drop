# Step 14: Hot Reload Setup

## Goal

Integrate Lurker library for automatic code reloading during development. Save file → see changes instantly.

## Dependencies

- **Step 01**: Core setup complete

## Files to Create/Modify

### Create
- Download `lib/lurker.lua` from https://github.com/rxi/lurker

### Modify
- `main.lua` - Require and update lurker

## Implementation

**Download lurker.lua:**
```bash
curl https://raw.githubusercontent.com/rxi/lurker/master/lurker.lua -o lib/lurker.lua
```

**In main.lua:**
```lua
local lurker = require("lib.lurker")

function love.update(dt)
    lurker.update()
    -- ... rest of update
end
```

## Configuration

Configure lurker to ignore certain files:
```lua
lurker.quiet = false  -- Show reload messages
lurker.interval = 0.5 -- Check every 0.5 seconds
```

## Testing

1. Run game
2. Edit a file (change bird color)
3. Save file
4. Game reloads automatically
5. See change without restart

## Notes

- Game state may reset on reload
- Very useful for iterating quickly
- Can disable for release builds

Next: [15-polish-and-extras.md](15-polish-and-extras.md)
