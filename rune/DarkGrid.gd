@tool
extends ColorRect

@onready var mat = material as ShaderMaterial

func _process(delta):
	mat.set_shader_parameter("mouse",get_local_mouse_position())
