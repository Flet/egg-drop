# Step 03: Dot Matrix Shader

## Goal

Add a Game Boy style dot matrix screen effect using a GLSL shader. This creates the retro CRT/LCD look by overlaying a grid pattern on the rendered game.

## Dependencies

- **Step 02**: Rendering pipeline must be complete
- Canvas system must be functional

## Files to Create/Modify

### Create
- `src/shaders/dotmatrix.glsl` - Dot matrix shader

### Modify
- `src/systems/renderer.lua` - Add shader support
- `main.lua` - Toggle shader on/off with F2

## Implementation Details

### 1. Create Dot Matrix Shader

**File: `src/shaders/dotmatrix.glsl`**

```glsl
// Dot Matrix Shader
// Creates Game Boy style screen door effect

// Pixel function (runs for each pixel)
vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords)
{
    // Sample the original pixel color
    vec4 pixel = Texel(texture, texture_coords);

    // Dot matrix parameters
    float dotSize = 0.8;        // Size of dots (0.0 to 1.0)
    float brightness = 1.1;     // Brightness multiplier
    float contrast = 0.95;      // Contrast adjustment

    // Calculate dot pattern
    vec2 gridPos = fract(screen_coords);  // Position within current pixel (0-1)

    // Create circular dots
    vec2 center = vec2(0.5, 0.5);
    float dist = distance(gridPos, center);
    float dotMask = 1.0 - smoothstep(dotSize * 0.35, dotSize * 0.5, dist);

    // Apply dot pattern
    pixel.rgb *= mix(contrast, brightness, dotMask);

    // Slight scanline effect (horizontal lines)
    float scanline = sin(screen_coords.y * 3.14159) * 0.05;
    pixel.rgb *= 1.0 - scanline;

    // Apply overall color
    pixel *= color;

    return pixel;
}
```

**Shader Explanation:**
- `effect()`: Main shader function, runs per-pixel
- `screen_coords`: Pixel position in screen space
- `texture_coords`: UV coordinates for sampling texture
- `fract()`: Gets fractional part (creates repeating pattern)
- `distance()`: Creates circular dots
- `smoothstep()`: Smooth transition between values
- `dotMask`: Where dots appear (bright) vs gaps (darker)

### 2. Update Renderer to Support Shader

**File: `src/systems/renderer.lua`** - Add to existing file:

```lua
-- Add at top
local Renderer = {}

function Renderer:init()
    -- ... existing code ...

    -- Load shader
    self.shader = nil
    self.shaderEnabled = true
    self:loadShader()

    -- ... rest of existing code ...
end

function Renderer:loadShader()
    -- Load dot matrix shader
    local success, result = pcall(function()
        return love.graphics.newShader("src/shaders/dotmatrix.glsl")
    end)

    if success then
        self.shader = result
        print("  Shader loaded successfully")
    else
        print("  Warning: Could not load shader - " .. result)
        self.shader = nil
    end
end

-- Modify finishDrawing function
function Renderer:finishDrawing()
    -- Reset render target to screen
    love.graphics.setCanvas()

    -- Clear screen with black (letterbox bars)
    love.graphics.clear(0, 0, 0)

    -- Apply shader if enabled
    if self.shaderEnabled and self.shader then
        love.graphics.setShader(self.shader)
    end

    -- Draw the scaled canvas to screen
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(
        self.canvas,
        self.offsetX,
        self.offsetY,
        0,  -- rotation
        self.scale,  -- scale X
        self.scale   -- scale Y
    )

    -- Reset shader
    love.graphics.setShader()
end

function Renderer:toggleShader()
    self.shaderEnabled = not self.shaderEnabled
    print("Shader " .. (self.shaderEnabled and "enabled" or "disabled"))
end

function Renderer:isShaderEnabled()
    return self.shaderEnabled and self.shader ~= nil
end

-- ... rest of existing code ...
```

### 3. Update main.lua for Shader Toggle

**File: `main.lua`** - Update keypressed function:

```lua
function love.keypressed(key)
    -- ESC to quit
    if key == "escape" then
        love.event.quit()
    end

    -- F1 to toggle debug
    if key == "f1" then
        DEBUG = not DEBUG
    end

    -- F2 to toggle shader
    if key == "f2" then
        Renderer:toggleShader()
    end
end
```

Also update the debug overlay to show shader status:

```lua
function drawDebugOverlay()
    -- Draw at full window resolution (not affected by canvas)
    if DEBUG then
        love.graphics.setColor(0, 1, 0)
        local stats = love.graphics.getStats()
        love.graphics.print("FPS: " .. love.timer.getFPS(), 10, 10)
        love.graphics.print("Draw Calls: " .. stats.drawcalls, 10, 25)
        love.graphics.print("Shader: " .. (Renderer:isShaderEnabled() and "ON" or "OFF") .. " (F2)", 10, 40)
        love.graphics.print("Debug: ON (F1)", 10, 55)
    end
end
```

## Testing

### 1. Run the Game

```bash
love .
```

### 2. Visual Verification

**With shader enabled:**
- Visible dot matrix pattern overlay
- Slight darkening between pixels
- Subtle scanline effect
- Game Boy LCD-like appearance
- Graphics still crisp and readable

### 3. Toggle Shader

Press F2 → Shader turns off (smooth pixels)
Press F2 again → Shader turns on (dot matrix)

### 4. Compare Before/After

**Without shader:**
- Smooth, clean pixels
- No pattern overlay

**With shader:**
- Dot pattern visible
- Authentic retro screen effect
- Slightly less bright in gaps

### 5. Check Console

Should print:
```
Shader loaded successfully
```

Or if shader fails:
```
Warning: Could not load shader - [error message]
```

### 6. Verify No Performance Impact

- FPS should remain at 60
- No stuttering or slowdown
- Shader is very lightweight

## Common Issues

### Issue: Shader not loading

**Cause:** File path wrong or syntax error in shader

**Fix:**
- Verify file at `src/shaders/dotmatrix.glsl`
- Check console for error message
- Check GLSL syntax (no semicolons missing, etc.)

### Issue: Black screen with shader on

**Cause:** Shader error causing render failure

**Fix:**
- Press F2 to disable shader
- Check console for shader compile errors
- Verify GLSL version compatibility

### Issue: Shader too strong/subtle

**Cause:** Parameters need adjustment

**Fix:** Edit dotmatrix.glsl and adjust:
- `dotSize`: Larger = bigger dots
- `brightness`: Higher = brighter
- `contrast`: Lower = more dramatic effect

### Issue: Pattern looks wrong at different scales

**Cause:** Screen coords not accounting for scaling

**Fix:** This is expected - pattern scales with resolution. For consistent look, you could pass scale as uniform to shader.

## Shader Parameter Tuning

Edit these values in `dotmatrix.glsl` to customize the effect:

```glsl
float dotSize = 0.8;        // Try: 0.5 - 1.0
float brightness = 1.1;     // Try: 1.0 - 1.3
float contrast = 0.95;      // Try: 0.8 - 1.0
```

**Experiment with:**
- **Subtle effect**: dotSize=0.9, brightness=1.05, contrast=0.98
- **Strong effect**: dotSize=0.7, brightness=1.2, contrast=0.9
- **Game Boy**: dotSize=0.75, brightness=1.15, contrast=0.92

## Next Steps

Once shader is working:
- Proceed to [04-bird-entity.md](04-bird-entity.md)
- Begin implementing actual game objects

## Notes

- Shader is optional (can be disabled with F2)
- Very low performance cost
- Can be enhanced later (color grading, CRT curvature, etc.)
- Game looks good with or without shader

## Advanced Shader Ideas (Future)

- CRT curvature (barrel distortion)
- Chromatic aberration
- Phosphor glow
- More accurate Game Boy color palette
- Adjustable intensity via uniform

## Checklist

- [ ] src/shaders/dotmatrix.glsl created
- [ ] Shader code has no syntax errors
- [ ] Renderer loads shader successfully
- [ ] Shader can be toggled with F2
- [ ] Dot matrix pattern visible when enabled
- [ ] Game still runs at 60 FPS
- [ ] Debug overlay shows shader status
- [ ] No black screen or render errors

## Estimated Time

20-30 minutes
