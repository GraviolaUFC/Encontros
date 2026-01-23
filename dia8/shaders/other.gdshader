shader_type canvas_item;

uniform sampler2D gradient: source_color;
uniform sampler2D screen_texture: hint_screen_texture, filter_nearest;

uniform float blur_radius: hint_range(1.0, 16.0, 1.0) = 1.0;
uniform float intensity: hint_range(0.0, 5.0, 0.1) = 0.5;
uniform float threshold: hint_range(0.0, 1.0) = 0.5;

void fragment() {
	COLOR = texture(screen_texture, SCREEN_UV);
	
	int r = int(blur_radius);
	float r2 = blur_radius*2.0;
	vec4 color = vec4(0.0);
	for (int x = -r; x < r; x++) {
		for (int y = -r; y < r; y++) {
			vec2 offset = vec2(float(x), float(y));
			vec2 uv = SCREEN_UV + offset * SCREEN_PIXEL_SIZE;
			vec4 c = texture(screen_texture, uv);
			float avg = max(max(c.r, c.g), c.b);
			if (avg >= threshold) {
				color += c / (r2*r2);
			}
		}
	}
	
	COLOR = texture(screen_texture, SCREEN_UV) + color * intensity;
}
