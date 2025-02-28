shader_type canvas_item;

render_mode blend_add;

uniform float inner_radius: hint_range(0.0, 1.0, 0.1) = 0.0;
uniform float transparency: hint_range(0.0, 1.0, 0.1) = 1.0;

void fragment() {
	vec2 centered_uv = (UV - vec2(0.5)) * 2.0f;
	float d = length(centered_uv);
	float l = sqrt(smoothstep(1.0, min(inner_radius, 0.99), d));
	COLOR = vec4(vec3(1.0), l * transparency);
}