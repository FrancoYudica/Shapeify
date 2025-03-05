shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE: hint_screen_texture;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {

	vec3 screen = texture(SCREEN_TEXTURE, SCREEN_UV).rgb;
	vec4 mask = texture(TEXTURE, UV);

	COLOR = vec4(vec3(1.0f) - screen, mask.a);
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
