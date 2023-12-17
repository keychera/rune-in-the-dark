shader_type canvas_item;

uniform float time = 0.;
uniform sampler2D rune_m;

uniform vec2 pos1 = vec2(1., 0.);
uniform vec2 pos2 = vec2(0., 0.);

uniform vec2 resolution;
uniform vec2 mouse;
#define RATIO (resolution.x/resolution.y)

float circle(in vec2 _uv, in vec2 _pos, in float _radius, in float grad) {
	vec2 uv = vec2(_uv.x, _uv.y / RATIO);
	vec2 pos = vec2(_pos.x, _pos.y / RATIO);
    float l = length(uv - pos);
	if (abs(grad - 0.) < 0.0001) {
		return step(l, _radius);
	} else {
		return smoothstep(l  ,l + grad, _radius);
	}  
}

float easeOutExpo(float x) {
	return 1. - pow(2., -10. * x);
}

void fragment() {
	vec4 c = texture(TEXTURE, UV);
	vec4 m_tex = texture(rune_m, UV);
	
	vec2 center = UV - 0.5;
	float max_time = .1;
	float progress = clamp(time / max_time, 0., 1.);
	vec2 pos = mix(pos1, pos2, easeOutExpo(progress));
	float inner = circle(center + (0.002 * vec2(sin(time), cos(time))), pos, 0.165, 0.01);
	float outer =  circle(center - (0.001 * vec2(sin(time), cos(time))), pos, 0.2, 0.01);
	c = mix(c, m_tex, (inner + outer) / 2.);

	float hop = 2.;
	vec2 m = floor(abs(mouse - 30.) * hop/60.) / hop;
	float factor = (1. - clamp((m.x + m.y)/2., 0., 1.)) * 0.5;
	
	c.rgb += m_tex.rgb * factor;

	COLOR = c;
}
