shader_type canvas_item;

uniform float amount: hint_range(0.0, 1.0);

void fragment() {
	vec4 c = texture(TEXTURE, UV);
	COLOR.rgb = mix(c.rgb, vec3(1.0, 1.0, 1.0), amount);
}
