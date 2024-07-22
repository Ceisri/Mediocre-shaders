shader_type spatial;
render_mode depth_draw_opaque, unshaded, shadows_disabled, cull_disabled;

uniform sampler2D earth_crack_texture : hint_white; // Texture for controlling color and transparency
uniform vec4 center_color : hint_color = vec4(1.0, 0.0, 0.0, 1.0); // Color for the center (red)
uniform vec4 edge_color : hint_color = vec4(1.0, 1.0, 0.0, 1.0); // Color for the edges (yellow)

// Fragment shader
void fragment() {
    // Sample the earth crack texture
    vec4 earth_crack_texture_color = texture(earth_crack_texture, UV);

    // Calculate the distance from the center
    float distance_from_center = length(UV - vec2(0.5, 0.5)); // Distance from the center of the UV space (0.5, 0.5)

    // Interpolate color based on distance from the center
    vec4 color = mix(edge_color, center_color, distance_from_center * 2.0); // Interpolate between edge and center colors

    // Determine transparency based on the earth crack texture's brightness
    float grey_brightness = dot(earth_crack_texture_color.rgb, vec3(0.299, 0.587, 0.114)); // Luminance calculation
    float alpha = (grey_brightness < 0.5) ? 0.0 : 1.0; // Fully transparent for dark parts

    // Set the final color and alpha
    ALBEDO = color.rgb;
    ALPHA = alpha;
}
