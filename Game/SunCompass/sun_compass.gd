class_name SunCompass
extends Node3D

@export_category("Animation")
@export var transition_duration: float = 0.45

@export_category("Compass")
@export var stowed_position: Vector3 = Vector3(0.0, -0.35, -0.8)
@export var deployed_position: Vector3 = Vector3(0.0, 0.25, -1.6)

@export_category("Camera")
@export var normal_camera_position: Vector3 = Vector3(0.0, 1.5, 0.0)
@export var inspection_camera_position: Vector3 = Vector3(0.0, 1.5, -0.1)
@export var inspection_camera_rotation: Vector3 = Vector3(
	deg_to_rad(-60.0),deg_to_rad(-0.0), deg_to_rad(-0.0))

@export var camera: Camera3D
@export var camera_controller: Node3D
@export var player: VikingCharacter3D

@onready var compass_pivot: Node3D = %CompassPivot

var is_deployed: bool = false
var is_transitioning: bool = false

var _tween: Tween
var _normal_camera_rotation: Vector3
var _normal_controller_rotation: Vector3


func _ready() -> void:
	compass_pivot.position = stowed_position
	camera.position = normal_camera_position
	_normal_controller_rotation = camera_controller.rotation


func toggle() -> void:
	if is_transitioning:
		return

	is_deployed = not is_deployed
	is_transitioning = true
	
	player.set_inspection_camera(is_deployed)

	if is_deployed:
		# Remember where the player was looking before inspection.
		_normal_camera_rotation = camera.rotation
		_normal_controller_rotation = camera_controller.rotation

	_tween = create_tween()
	_tween.set_parallel(true)
	_tween.set_trans(Tween.TRANS_CUBIC)
	_tween.set_ease(Tween.EASE_IN_OUT)

	if is_deployed:
		_tween.tween_property(
			compass_pivot, "position",
			deployed_position, transition_duration
		)
		_tween.tween_property(
			camera, "position",
			inspection_camera_position, transition_duration
		)
		_tween.tween_property(
			camera_controller, "rotation",
			inspection_camera_rotation, transition_duration
		)
	else:
		_tween.tween_property(
			compass_pivot, "position",
			stowed_position, transition_duration
		)
		_tween.tween_property(
			camera, "position",
			normal_camera_position, transition_duration
		)
		_tween.tween_property(
			camera_controller, "rotation",
			_normal_controller_rotation, transition_duration
		)

	_tween.set_parallel(false)
	_tween.tween_callback(_finish_transition)


func _finish_transition() -> void:
	is_transitioning = false
	if not is_deployed:
		player.sync_camera_rotation()
