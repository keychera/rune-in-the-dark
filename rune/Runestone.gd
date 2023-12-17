@tool
extends TextureButton
class_name Runestone

@onready var mat = (material as ShaderMaterial)
@onready var light_up = $on_active as GPUParticles2D

@export var order : int = 0
@export var symbol_n : int = 0

@export_subgroup("textures")
@export var texture_idle : Texture2D
@export var texture_active : Texture2D

@export_subgroup("internal state")
@export var active : bool = false
@export var done : bool = false

@export var light_sources = Dictionary()

func _process(delta):
	mat.set_shader_parameter("time", mat.get_shader_parameter("time") + delta)
	mat.set_shader_parameter("mouse", get_local_mouse_position())

func set_symbol(sym: int):
	symbol_n = sym
	mat.set_shader_parameter("symbol_active", load(str("res://rune/symbols/", str(sym), "l.png")));
	mat.set_shader_parameter("symbol", load(str("res://rune/symbols/", str(sym), ".png")));

func toggle_active(force_state = null):
	if force_state != null:
		active = force_state
	else:
		active = !active
	mat.set_shader_parameter("active", active)
	texture_normal = texture_active if active else texture_idle
	light_up.restart()
	light_up.emitting = true

func toggle_done(force_state = null):
	if force_state != null:
		done = force_state
	else:
		done = !done
	mat.set_shader_parameter("done", done)
	disabled = done


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
	
	mat.set_shader_parameter("circle_size", 0.17 + (0.04 * light_sources.size()))
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
	mat.set_shader_parameter("circle_size", 0.17 + (0.04 * light_sources.size()))
	mat.set_shader_parameter("time", 0.)
