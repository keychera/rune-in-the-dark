@tool
extends Button
class_name Rune

func _process(delta):
	(material as ShaderMaterial).set_shader_parameter("mouse", get_local_mouse_position())
