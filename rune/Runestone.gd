extends TextureButton
class_name Runestone

@onready var mat = (material as ShaderMaterial)

@export var debug : Vector2

func _process(delta):
	mat.set_shader_parameter("time", mat.get_shader_parameter("time") + delta)
	debug = Vector2(get_local_mouse_position().x - 30., get_local_mouse_position().y - 30.)
	

func _on_mouse_entered():
	mat.set_shader_parameter("pos1", mat.get_shader_parameter("pos2"))
	mat.set_shader_parameter("pos2", Vector2(0, 0))
	mat.set_shader_parameter("time", 0.)


func _on_mouse_exited():
	var original = get_local_mouse_position()
	var offset_mouse = Vector2(original.x - 30., original.y - 30.)
	var normalized_mouse = offset_mouse/60;
	mat.set_shader_parameter("pos1", mat.get_shader_parameter("pos2"))
	if (abs(normalized_mouse.x) < 1. && abs(normalized_mouse.y) < 1.):
		mat.set_shader_parameter("pos2", sign(round(normalized_mouse)) * 0.18)
	else:
		# for now, this will only reach if you move the mouse really fast, touching the control and move further away
		mat.set_shader_parameter("pos2", sign(round(normalized_mouse)) * 0.42)
	mat.set_shader_parameter("time", 0.)
