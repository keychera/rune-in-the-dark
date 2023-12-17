shader_type canvas_item;

uniform vec2 mouse; 

void fragment() {
	float hop = 2.;
	vec2 m = floor(abs(mouse - 30.) * hop/60.) / hop;
	float factor = 1. - clamp((m.x + m.y)/2., 0., 1.);
	COLOR.rgb = vec3(0.2) * factor;
}
