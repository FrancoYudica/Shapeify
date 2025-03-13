shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE: hint_screen_texture;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {

	vec3 screen = texture(SCREEN_TEXTURE, SCREEN_UV).rgb;
	vec4 mask = texture(TEXTURE, UV);

	vec4 inv_color = vec4(vec3(1.0f) - screen, 1.0);
	vec4 base_color = vec4(vec3(0.0f), 0.0);
	COLOR = mix(base_color, inv_color, mask.a);
}