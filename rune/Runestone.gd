@tool
extends Sprite2D
class_name Runestone

@export var last_mouse : Vector2

@onready var mat = (material as ShaderMaterial)

func _process(delta):
	mat.set_shader_parameter("time", mat.get_shader_parameter("time") + delta)
	mat.set_shader_parameter("mouse", get_local_mouse_position())
