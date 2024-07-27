shader_type spatial;
render_mode depth_draw_opaque, unshaded, shadows_disabled, cull_disabled;

uniform sampler2D albedo_texture : hint_albedo;
uniform sampler2D noise_texture;
uniform sampler2D visibility_noise_texture;
uniform sampler2D lightning_noise_texture; // New noise texture for vertex displacement
uniform float scroll_speed = 1.0;
uniform float visibility_scroll_speed = 1.0;
uniform float lightning_scroll_speed = 1.0; // Speed for lightning noise texture
uniform vec4 base_color : hint_color;
uniform vec4 pulse_color : hint_color;

void vertex() {
    // Scroll the lightning noise texture over time
    vec2 lightning_noise_uv = UV + vec2(TIME * lightning_scroll_speed, TIME * lightning_scroll_speed);
    float lightning_noise_value = texture(lightning_noise_texture, lightning_noise_uv).r;

    // Apply vertex displacement for a lightning strike effect
    vec3 displacement = vec3(lightning_noise_value - 0.5) * 0.1; // Adjust the scale for intensity
    VERTEX += displacement;
}

void fragment() {
    vec4 albedo = texture(albedo_texture, UV);
    if (albedo.rgb == vec3(0.0)) {
        discard;
    }

    // Scroll the primary noise texture for pulsing effect
    vec2 noise_uv = UV + vec2(TIME * scroll_speed, 0.0);
    float noise_value = texture(noise_texture, noise_uv).r;

    // Scroll the visibility noise texture over time
    vec2 visibility_noise_uv = UV + vec2(TIME * visibility_scroll_speed, 0.0);
    float visibility_noise_value = texture(visibility_noise_texture, visibility_noise_uv).r;

    // Create a pulsing effect
    float time = TIME * 2.0; // Adjust this to control pulse speed
    float pulse = sin(time) * 0.5 + 0.5; // Range from 0.0 to 1.0

    // Interpolate between base color and pulse color using the pulsing effect
    vec4 interpolated_color = mix(base_color, pulse_color, pulse);

    // Calculate final color with base and pulse colors
    vec3 final_color = albedo.rgb * interpolated_color.rgb;

    // Modulate alpha with visibility noise texture
    float final_alpha = albedo.a * interpolated_color.a * visibility_noise_value;

    // Output final color and alpha
    ALBEDO = final_color;
    ALPHA = final_alpha;
}
