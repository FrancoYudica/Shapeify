shader_type canvas_item;


void fragment() {
	float t = ceil(texture(TEXTURE, UV).a);
	COLOR = vec4(vec3(t), 1.0);
}
