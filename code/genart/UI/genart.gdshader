shader_type canvas_item;

uniform float t = 1.0;

const float max_length = sqrt(2);

void fragment() {
	vec2 centered_uv = (UV - 0.5) * 2.0;
	float center_length = length(centered_uv);

	float d = sqrt(max_length - center_length);

	float expand_factor = 1.0 + sin(TIME * 10.0) * 0.2 * mix(0.0, d, t);
	vec2 expanded_uv = centered_uv * expand_factor;
	vec2 uv = expanded_uv * 0.5 + 0.5;
	COLOR = texture(TEXTURE, uv);
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
