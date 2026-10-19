extends Node3D

@onready var shadow_mesh: MeshInstance3D = $ArrowShadow
const SHADOW_LENGTH_CURVE = preload("uid://dhuvup4jcrldn")

@export var rotation_speed: float = 5.0
var global_time: float = 0.0

const DEGREES_PER_HOUR: float = 15.0
const DEGREES_OFFSET: float = 180
const MIN_SCALE: float = 0.15
const SCALE_DIFF: float = 0.18
const SCALE_DEGREES_OFFSET: float = -30

func _ready() -> void:
	Game.time_system.time_changed.connect(_on_world_time_changed)

func _on_world_time_changed(hours: float) -> void:
	var degrees: float = hours * DEGREES_PER_HOUR + DEGREES_OFFSET
	var wrapped = fposmod(degrees + 180.0, 360.0) - 180.0
	global_rotation_degrees.y = -wrapped
	var wrapped2 = fposmod(wrapped + 180.0 + DEGREES_OFFSET, 360.0) - 180.0
	shadow_mesh.scale.y = MIN_SCALE + SCALE_DIFF * SHADOW_LENGTH_CURVE.sample(wrapped2)
	shadow_mesh.position.z = -0.5 * shadow_mesh.scale.y
	print(-shadow_mesh.global_basis.z)

func _process(delta: float) -> void:
	var hours : float = Game.time_system.hour
	var degrees: float = hours * DEGREES_PER_HOUR  + DEGREES_OFFSET
	var wrapped = fposmod(degrees + 180.0, 360.0) - 180.0
	global_rotation_degrees.y = -wrapped
