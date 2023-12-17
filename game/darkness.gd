@tool
extends ColorRect

func _ready():
	(material as ShaderMaterial).set_shader_parameter("resolution", size)

func _process(delta):
	(material as ShaderMaterial).set_shader_parameter("mouse", get_local_mouse_position())
