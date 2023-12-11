extends Button

func _process(delta):
	material.set_shader_parameter("mouse", get_local_mouse_position())

