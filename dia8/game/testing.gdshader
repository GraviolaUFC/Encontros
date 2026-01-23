shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
uniform float offset: hint_range(1.0, 16.0, 1.0);

void fragment() {
	vec2 uv = SCREEN_UV;
    vec3 red_channel = texture(screen_texture, uv - offset*SCREEN_PIXEL_SIZE).rgb;
	vec3 green_channel = texture(screen_texture, uv).rgb;
	vec3 blue_channel = texture(screen_texture, uv + offset*SCREEN_PIXEL_SIZE).rgb;
	
    COLOR.rgb = vec3(red_channel.r, green_channel.g, blue_channel.b);
}