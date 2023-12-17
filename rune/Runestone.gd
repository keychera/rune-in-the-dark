@tool
extends Sprite2D
class_name Runestone

@onready var mat = (material as ShaderMaterial)

func _process(delta):
	mat.set_shader_parameter("time", mat.get_shader_parameter("time") + delta)
	

func _on_mouse_entered():
	print("enter")
	mat.set_shader_parameter("pos1", mat.get_shader_parameter("pos2"))
	mat.set_shader_parameter("pos2", Vector2(0, 0))
	mat.set_shader_parameter("time", 0.)


func _on_mouse_exited():
	print("exit")
	var normalized_mouse = get_local_mouse_position()/60;
	mat.set_shader_parameter("pos1", mat.get_shader_parameter("pos2"))
	if (abs(normalized_mouse.x) < 1. && abs(normalized_mouse.y) < 1.):
		mat.set_shader_parameter("pos2", sign(round(normalized_mouse)) * 0.18)
	else:
		# for now, this will only reach if you move the mouse really fast, touching the control and move further away
		mat.set_shader_parameter("pos2", sign(round(normalized_mouse)) * 0.42)
	mat.set_shader_parameter("time", 0.)
