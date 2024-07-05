shader_type spatial;

uniform vec3 water_color : source_color;
uniform sampler2D water_normal_noise;

uniform sampler2D screen_texture : hint_screen_texture;

void fragment() {
	
	ALBEDO = mix(texture(screen_texture, SCREEN_UV).rgb, water_color, 0.9);
	
	NORMAL_MAP = texture(water_normal_noise, UV).rgb;
	NORMAL *= 0.2; // bump strength
	
	ROUGHNESS = 0.2;
}