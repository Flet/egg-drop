# Peg Specifications

Detailed specifications for all peg types in the game.

## Square Peg (Destructible)

### Visual
- **Shape**: Rectangle
- **Size**: 4x4 pixels
- **Colors**:
  - State 0 (Unhit): White `(1, 1, 1)`
  - State 1 (1 hit): Pink `(1, 0.5, 1)`
  - State 2 (2 hits): Red `(1, 0, 0)`
  - State 3 (Destroyed): Not rendered

### Behavior
- **Hits to Destroy**: 3
- **Bounces Eggs**: Yes
- **Collision Shape**: Rectangle (4x4)
- **State Progression**: White → Pink → Red → Destroyed

### Physics
- **Bounce Coefficient**: 0.7
- **Friction**: 0.98
- **Static**: Yes (doesn't move)

### Code Example
```lua
{
    type = "square",
    x = 100,
    y = 100,
    width = 4,
    height = 4,
    hits = 0,
    maxHits = 3,
    destroyed = false
}
```

## Round Peg (Indestructible)

### Visual
- **Shape**: Circle
- **Diameter**: 12 pixels (visual)
- **Radius**: 6 pixels (collision)
- **Bounding Box**: ~12x12 pixels (for grid alignment)
- **Color**: White `(1, 1, 1)`

### Behavior
- **Hits to Destroy**: Infinite (never destroyed)
- **Bounces Eggs**: Yes
- **Collision Shape**: Circle (radius 6)
- **State**: Always active

### Physics
- **Bounce Coefficient**: 0.7
- **Friction**: 0.98
- **Static**: Yes

### Code Example
```lua
{
    type = "round",
    x = 100,
    y = 100,
    radius = 6,
    indestructible = true
}
```

## Triangle Bumper (Future)

### Visual
- **Shape**: Triangle
- **Size**: 8x8 pixels (bounding box)
- **Orientations**: 4 (up, down, left, right)
- **Color**: White `(1, 1, 1)`
- **Accent**: Yellow tip `(1, 1, 0)` pointing in facing direction

### Behavior
- **Directional Bounce**: Stronger reflection in facing direction
- **Bounces Eggs**: Yes
- **Collision Shape**: Triangle (3 line segments)
- **Indestructible**: Yes

### Physics
- **Base Bounce**: 0.8
- **Directional Boost**: 1.3x in facing direction
- **Friction**: 0.95

### Orientations
- **Up** `△`: Points upward, boosts upward velocity
- **Down** `▽`: Points downward, redirects downward
- **Left** `◁`: Points left, boosts leftward
- **Right** `▷`: Points right, boosts rightward

### Code Example
```lua
{
    type = "triangle",
    x = 100,
    y = 100,
    size = 8,
    rotation = 0,  -- 0=up, 90=right, 180=down, 270=left
    facing = "up"  -- "up", "down", "left", "right"
}
```

## Collision Detection

### Square Peg

**Circle-Rectangle collision:**
```lua
function circleRectCollision(cx, cy, radius, rx, ry, rw, rh)
    -- Find closest point on rectangle
    local closestX = math.max(rx, math.min(cx, rx + rw))
    local closestY = math.max(ry, math.min(cy, ry + rh))

    -- Check distance
    local dx = cx - closestX
    local dy = cy - closestY
    return (dx * dx + dy * dy) < (radius * radius)
end
```

### Round Peg

**Circle-Circle collision:**
```lua
function circleCircleCollision(x1, y1, r1, x2, y2, r2)
    local dx = x2 - x1
    local dy = y2 - y1
    local distance = math.sqrt(dx * dx + dy * dy)
    return distance < (r1 + r2)
end
```

### Triangle Bumper

**Point-in-Triangle test + closest edge:**
```lua
-- More complex, involves checking each edge
-- and finding closest point on triangle
```

## Grid Symbols

For level definition files:

```lua
-- Legend:
-- ■ = Square peg (4x4)
-- ● = Round peg (12px diameter)
-- △ = Triangle up
-- ▽ = Triangle down
-- ◁ = Triangle left
-- ▷ = Triangle right
```

## Placement Guidelines

### Square Pegs
- Align to 4-pixel grid for clean look
- Space at least 8 pixels apart for eggs to pass
- Good for creating walls and barriers

### Round Pegs
- Center on even coordinates (divisible by 2)
- Effective radius for bouncing: ~10 pixels
- Good for bouncing eggs in specific directions

### Triangle Bumpers
- Place facing toward targets or desired paths
- Effective for redirecting eggs
- Combine with round pegs for complex bounces

## Peg Density

**Recommended spacing:**
- Minimum 6-8 pixels between pegs
- Egg radius = 3, peg width/radius = 4-6
- Total gap = 8px allows eggs to pass
- Closer spacing = more difficult/bouncy

**Density by area:**
- Sparse: 1 peg per 400 square pixels (20x20 area)
- Medium: 1 peg per 256 square pixels (16x16 area)
- Dense: 1 peg per 144 square pixels (12x12 area)

## Physics Tuning

### Bounce Feel

**Bouncier (more arcade-y):**
```lua
bounce = 0.85
friction = 0.99
upwardBias = 0.7  -- Strong upward bias
```

**Less Bouncy (more realistic):**
```lua
bounce = 0.5
friction = 0.95
upwardBias = 0.9  -- Minimal bias
```

**Default (balanced):**
```lua
bounce = 0.7
friction = 0.98
upwardBias = 0.85
```

## Peg Type Registry Structure

```lua
local PegTypes = {
    square = {
        shape = "rectangle",
        size = {4, 4},
        destructible = true,
        maxHits = 3,
        states = {"white", "pink", "red"},
        colors = {
            {1, 1, 1},
            {1, 0.5, 1},
            {1, 0, 0}
        },
        bounce = 0.7,
        friction = 0.98
    },

    round = {
        shape = "circle",
        radius = 6,
        destructible = false,
        color = {1, 1, 1},
        bounce = 0.7,
        friction = 0.98
    },

    triangle = {
        shape = "triangle",
        size = 8,
        destructible = false,
        directional = true,
        bounce = 0.8,
        boostMultiplier = 1.3,
        friction = 0.95
    }
}
```

## Adding New Peg Types

To add a new peg type:

1. Define in peg type registry
2. Add rendering function
3. Add collision detection
4. Add grid symbol
5. Update level parser
6. Test bouncing behavior

Example new type - **Star Peg**:
```lua
star = {
    shape = "star",
    points = 5,
    radius = 5,
    destructible = false,
    specialEffect = "spin",  -- Egg spins on hit
    bounce = 0.9,  -- Extra bouncy
    gridSymbol = "★"
}
```
