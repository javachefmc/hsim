shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

uniform float offset = 0;

void fragment() {
	vec4 red_channel = texture(SCREEN_TEXTURE, vec2(SCREEN_UV.x + (SCREEN_PIXEL_SIZE.x * offset), SCREEN_UV.y));
	vec4 green_channel = texture(SCREEN_TEXTURE, SCREEN_UV);
	vec4 blue_channel = texture(SCREEN_TEXTURE, vec2(SCREEN_UV.x - (SCREEN_PIXEL_SIZE.x * offset), SCREEN_UV.y));
	COLOR = vec4(red_channel.r, green_channel.g, blue_channel.b, 1);
}
