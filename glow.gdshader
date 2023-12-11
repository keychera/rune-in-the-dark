shader_type canvas_item;


uniform float bloom_i : hint_range(0.0, 0.03, 0.002)  = 0.02;
uniform vec3 glow_color : source_color;
uniform float glow_i : hint_range(0.0, 1.0, 0.01) = 0.5;

vec4 get_bloom(sampler2D tex, vec2 uv, vec3 color) {
	vec4 bloom; float i = bloom_i;
	bloom += texture(tex, vec2(uv.x + i, uv.y + i));
	bloom += texture(tex, vec2(uv.x - i, uv.y + i));
	bloom += texture(tex, vec2(uv.x + i, uv.y - i));
	bloom += texture(tex, vec2(uv.x - i, uv.y - i));
	bloom.rgb = color;
	return bloom;
}

void fragment() {
	vec4 col = texture(TEXTURE, UV);
	if (col.a < 0.01) {
		col = get_bloom(TEXTURE, UV, vec3(0.9, 0.9, 0.7));
	}
	if (col.a < 0.01) {
		vec4 glow;
		glow.rgb = glow_color;
		glow.a = glow_i - length(abs(UV - 0.5) * 2.);
		col = glow;
	}
	COLOR = col;
}