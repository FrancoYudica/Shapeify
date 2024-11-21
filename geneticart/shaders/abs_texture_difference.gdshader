// Calculates the absolute difference between two textures
shader_type canvas_item;

uniform sampler2D target_texture;
uniform sampler2D current_texture;


void fragment() {
	vec3 difference = abs(texture(target_texture, UV).rgb - texture(current_texture, UV).rgb);
	COLOR = vec4(difference, 1.0f);
}
