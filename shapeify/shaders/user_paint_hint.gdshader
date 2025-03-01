shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE: hint_screen_texture;

uniform float smoothing = 0.05;
uniform float inner_radius = 0.9;
uniform float rotating = 1.0f;

void fragment() {
	vec2 centered_uv = 2.0f * UV - vec2(1.0f);
	float l = length(centered_uv);
	float a = smoothstep(inner_radius - smoothing, inner_radius, l) * smoothstep(1.0, inner_radius + smoothing, l);


	float angle = atan(centered_uv.y / centered_uv.x) + TIME * rotating;
	float d = smoothstep(0.5 - smoothing, 0.5 + smoothing, abs(sin(angle * 6.0f)));

	vec4 screen_color = texture(SCREEN_TEXTURE, SCREEN_UV);
	vec3 inv_color = vec3(1.0) - screen_color.rgb;

	COLOR = vec4(inv_color, a * d) ;
}