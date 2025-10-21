# Color Palette Reference

Nintendo Land Coin Game inspired color palette for retro aesthetic.

## Background

**Gradient (Top to Bottom):**
- Top: `#00D9D9` - Cyan - `rgb(0, 217, 217)` - `(0, 0.85, 0.85)`
- Bottom: `#0000FF` - Blue - `rgb(0, 0, 255)` - `(0, 0, 1)`

**Usage:**
```lua
-- Vertical gradient
for y = 0, height do
    local t = y / height
    local r = 0 + (0 - 0) * t
    local g = 0.85 + (0 - 0.85) * t
    local b = 0.85 + (1 - 0.85) * t
    love.graphics.setColor(r, g, b)
end
```

## UI Panels

- **Panel Background**: `#00D9D9` - Cyan/Teal - `(0, 0.85, 0.85)`
- **Panel Text**: `#FFFFFF` - White - `(1, 1, 1)`
- **Border Main**: `#FFFFFF` - White - `(1, 1, 1)`
- **Border Accent**: `#FF00FF` - Magenta/Pink - `(1, 0, 1)`

## Game Objects

### Square Pegs (Destructible)
- **State 1 (Unhit)**: `#FFFFFF` - White - `(1, 1, 1)`
- **State 2 (1 hit)**: `#FF80FF` - Pink - `(1, 0.5, 1)`
- **State 3 (2 hits)**: `#FF0000` - Red - `(1, 0, 0)`
- **State 4 (3 hits)**: Destroyed (not visible)

### Round Pegs (Indestructible)
- **Color**: `#FFFFFF` - White - `(1, 1, 1)`

### Targets
- **Blue (Unhit)**: `#0080FF` - Blue - `(0, 0.5, 1)`
- **Orange (Hit)**: `#FFA500` - Orange - `(1, 0.65, 0)`
- **Border**: `#FFFFFF` - White - `(1, 1, 1)`

**Animation Colors:**
```lua
-- Pulse between blue and orange
local t = (math.sin(time * 8) + 1) / 2
local r = 0 + (1 - 0) * t
local g = 0.5 + (0.65 - 0.5) * t
local b = 1 + (0 - 1) * t
```

### Bird
- **Body**: `#FFFFFF` - White - `(1, 1, 1)`
- **Beak**: `#FFC800` - Yellow/Gold - `(1, 0.78, 0)`

### Eggs
- **Main**: `#FFF5E6` - Off-white/Cream - `(1, 0.96, 0.9)`
- **Highlight**: `#FFFFFF` - White - `(1, 1, 1)` at 50% opacity

### Walls
- **Color**: `#FFFFFF` - White - `(1, 1, 1)`

## Helper Functions

```lua
-- Hex to Love2D color
function hexToColor(hex)
    hex = hex:gsub("#","")
    return {
        tonumber("0x"..hex:sub(1,2)) / 255,
        tonumber("0x"..hex:sub(3,4)) / 255,
        tonumber("0x"..hex:sub(5,6)) / 255
    }
end

-- Example:
local cyan = hexToColor("#00D9D9")
love.graphics.setColor(cyan[1], cyan[2], cyan[3])
```

## Palette Swatches

For visual reference when designing:

```
████ #00D9D9 Cyan (Background Top)
████ #0000FF Blue (Background Bottom)
████ #FFFFFF White (Pegs, Text, Border)
████ #FF80FF Pink (Square Peg Hit 1)
████ #FF0000 Red (Square Peg Hit 2)
████ #0080FF Blue (Target Unhit)
████ #FFA500 Orange (Target Hit)
████ #FF00FF Magenta (Border Accent)
████ #FFC800 Yellow (Bird Beak)
████ #FFF5E6 Cream (Egg)
```

## Color Blindness Considerations

Current palette should work for most types of color blindness:
- Blue/Orange targets have good contrast
- Peg states differ in brightness (white > pink > red)
- Can add patterns/symbols if needed

## Dark Mode (Optional Future Feature)

Alternative palette for dark mode:

- Background: `#1A1A2E` → `#16213E`
- UI Panels: `#0F3460`
- Emphasis: Keep orange/blue for targets
