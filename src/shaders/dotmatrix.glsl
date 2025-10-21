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
