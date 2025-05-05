shader_type canvas_item;

uniform float time : hint_range(0.0, 5.0);
uniform float shard_size = 16.0;
uniform float explode_strength = 100.0;

// Pseudo-random function
float rand(vec2 co) {
    return fract(sin(dot(co, vec2(12.9898, 78.233))) * 43758.5453);
}

void fragment() {
    // Create a grid cell
    vec2 cell = floor(UV * shard_size);
    vec2 cell_center = (cell + 0.5) / shard_size;

    // Random direction per cell
    float angle = rand(cell) * 6.2831; // 2π
    vec2 dir = vec2(cos(angle), sin(angle));

    // Offset UV by explosion
    vec2 offset = dir * time * explode_strength / shard_size;
    vec2 uv_offset = UV - offset;

    // Sample from displaced texture
    COLOR = texture(TEXTURE, uv_offset);
}
