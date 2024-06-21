shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture;

// Film Grain
uniform float grain_amount : hint_range(0.0, 1.0) = 0.05; // Adjust the amount of grain
uniform float grain_size : hint_range(0.1, 10.0) = 1.0; // Adjust the size of the grain
uniform bool grain_animate = false;

// Chromatic Abberation
uniform int ca_levels = 3;
uniform float ca_spread = 0.01;
uniform float ca_mix = 0.5;

void fragment() {
	// CHROMATIC ABBERATION
	vec3 color_rgb = texture(SCREEN_TEXTURE, SCREEN_UV).rgb;
	
	vec3 sum;
	vec3 abberation = vec3(0);
	vec2 offset = (UV - vec2(0.5)) * vec2(1, -1);
	for(int i = 0; i < ca_levels; i++){
		float t = 2.0 * float(i) / float(ca_levels - 1); // range 0.0->2.0
		
		vec3 slice = vec3(1.0 - t, 1.0 - abs(t - 1.0), t - 1.0);
		slice = max(slice, 0.0);
		
		sum += slice;
		vec2 slice_offset = (t - 1.0) * ca_spread * offset;
		abberation += slice * texture(SCREEN_TEXTURE, SCREEN_UV + slice_offset).rgb;
	}
	abberation /= sum;
	// Mix original back in
	COLOR.rgb = mix(color_rgb, abberation, ca_mix);
	
	// FILM GRAIN
	
	// Sample the original screen texture
	vec4 original_color = texture(SCREEN_TEXTURE, SCREEN_UV);
	original_color.rgb = COLOR.rgb;
	
	float noise = 0.0;
	
	if (grain_animate) {
		// Generate random noise
		noise = (fract(sin(dot(UV * TIME, vec2(12.9898, 78.233))) * 43758.5453) - 0.5) * 2.0;
	} else {
		 noise = (fract(sin(dot(UV, vec2(12.9898, 78.233))) * 43758.5453) - 0.5) * 2.0;
	}
	// Add noise to the original color
	original_color.rgb += noise * grain_amount * grain_size;
	
	// Clamp the final color to make sure it stays in the valid range
	COLOR = clamp(original_color, 0.0, 1.0);
}