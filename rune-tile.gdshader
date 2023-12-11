shader_type canvas_item;

uniform vec2 mouse; 

void fragment() {
	vec2 mouse_pos = mouse/60.;
	vec3 glow = vec3(0.5 - length(UV - mouse_pos));
	COLOR.rgb = vec3(0.18) + glow;
}
