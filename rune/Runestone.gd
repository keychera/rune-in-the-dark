@tool
extends TextureButton
class_name Runestone

@onready var mat = (material as ShaderMaterial)
@onready var light_up = $on_active as GPUParticles2D

@export var active : bool = false
@export_subgroup("textures")
@export var texture_idle : Texture2D
@export var texture_active : Texture2D

@export var light_sources = Dictionary()

func _process(delta):
	mat.set_shader_parameter("time", mat.get_shader_parameter("time") + delta)
	mat.set_shader_parameter("mouse", get_local_mouse_position())

func toggle_active():
	active = !active
	mat.set_shader_parameter("active", active)
	texture_normal = texture_active if active else texture_idle
	if active:
		light_up.restart()
		light_up.emitting = true

const SCALE = 0.18;

@export var before: Vector2
@export var after: Vector2

func side_glow(source: int, from: Vector2):
	if light_sources.is_empty():
		mat.set_shader_parameter("pos1", from)
		mat.set_shader_parameter("pos2", from * SCALE)
		light_sources[source] = from
	else:
		before = light_sources.values().reduce(func(a :Vector2, b:Vector2): return (a + b)/2)
		mat.set_shader_parameter("pos1", before * SCALE)
		light_sources[source] = from
		after = light_sources.values().reduce(func(a :Vector2, b:Vector2): return (a + b)/2)
		mat.set_shader_parameter("pos2", after * SCALE)

	mat.set_shader_parameter("time", 0.)
	
func deglow(source: int):
	before = light_sources.values().reduce(func(a :Vector2, b:Vector2): return (a + b)/2)
	mat.set_shader_parameter("pos1", before * SCALE)
	light_sources.erase(source)
	if light_sources.is_empty():
		mat.set_shader_parameter("pos2", Vector2(100, 100))
	else:
		after = light_sources.values().reduce(func(a :Vector2, b:Vector2): return (a + b)/2)
		mat.set_shader_parameter("pos2", after * SCALE)
	mat.set_shader_parameter("time", 0.)


#func _on_mouse_entered():
#	mat.set_shader_parameter("pos1", mat.get_shader_parameter("pos2"))
#	mat.set_shader_parameter("pos2", Vector2(0, 0))
#	mat.set_shader_parameter("time", 0.)
#
#func _on_mouse_exited():
#	var original = get_local_mouse_position()
#	var offset_mouse = Vector2(original.x - 30., original.y - 30.)
#	var normalized_mouse = offset_mouse/60;
#	mat.set_shader_parameter("pos1", mat.get_shader_parameter("pos2"))
#	if (abs(normalized_mouse.x) < 1. && abs(normalized_mouse.y) < 1.):
#		mat.set_shader_parameter("pos2", sign(round(normalized_mouse)) * 0.18)
#	else:
#		# for now, this will only reach if you move the mouse really fast, touching the control and move further away
#		mat.set_shader_parameter("pos2", sign(round(normalized_mouse)) * 0.42)
#	mat.set_shader_parameter("time", 0.)



