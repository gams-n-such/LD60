extends Node3D

@onready var shadow_mesh: MeshInstance3D = $ArrowShadow
@onready var time_input: LineEdit = $"../LineEdit"
const SHADOW_LENGTH_CURVE = preload("uid://dhuvup4jcrldn")

@export var rotation_speed: float = 5.0
var global_time: float = 0.0

const DEGREES_PER_HOUR: float = 15.0
const DEGREES_OFFSET: float = 120
const MIN_SCALE: float = 0.13
const SCALE_DIFF: float = 0.18
const SCALE_DEGREES_OFFSET: float = -30

func _ready() -> void:
	time_input.text_changed.connect(_on_time_input_changed)
	
func _process(delta: float) -> void:
	global_time += rotation_speed * delta
	_on_time_input_changed_float(global_time)
	
func _on_time_input_changed(new_text: String) -> void:
	if new_text.is_valid_float():
		var hours: float = new_text.to_float()
		_on_time_input_changed_float(hours)
	else:
		pass
		
func _on_time_input_changed_float(hours: float) -> void:
	var degrees: float = hours * DEGREES_PER_HOUR
	var wrapped = fposmod(degrees + 180.0, 360.0) - 180.0
	rotation_degrees.y = - wrapped
	var wrapped2 = fposmod(wrapped + 180.0 + DEGREES_OFFSET, 360.0) - 180.0
	shadow_mesh.scale.y = MIN_SCALE + SCALE_DIFF * SHADOW_LENGTH_CURVE.sample(wrapped2)
	shadow_mesh.position.z = -0.5 * shadow_mesh.scale.y
