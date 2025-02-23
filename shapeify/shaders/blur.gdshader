shader_type canvas_item;

uniform float lod: hint_range(0.0, 5.0) = 0.0;
uniform vec4 tint: source_color = vec4(1.0f);
uniform sampler2D SCREEN_TEXTURE: hint_screen_texture, filter_linear_mipmap;

void fragment() {
	vec4 color = texture(SCREEN_TEXTURE, SCREEN_UV, lod);
	COLOR = vec4(color.rgb, 1.0) * tint;
}