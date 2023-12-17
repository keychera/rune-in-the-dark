shader_type canvas_item;

uniform vec2 resolution;
uniform vec2 mouse;
#define RATIO (resolution.x/resolution.y)

float circle(in vec2 _uv, in vec2 _pos, in float _radius, in float grad) {
	vec2 uv = vec2(_uv.x, _uv.y / RATIO);
	vec2 pos = vec2(_pos.x, _pos.y / RATIO);
    float l = length(uv - pos);
    return smoothstep(l  ,l + grad, _radius);
}

// https://thndl.com/square-shaped-shaders.html
float square(in vec2 _uv, float size) {
	vec2 uv = vec2(_uv.x, _uv.y / RATIO);
	vec2 r = abs(uv);
	float s = max(r.x, r.y);
	return smoothstep(size, size + 0.02, s);
}

void fragment() {
	vec2 mouse_pos = mouse/resolution;
	float a_circle = circle(UV, mouse_pos, 0.05, 0.05);
	float factor = 1. - square(UV - 0.5, 0.155);
	a_circle *= factor;
	COLOR.rgb = vec3(0.) + a_circle;
}
