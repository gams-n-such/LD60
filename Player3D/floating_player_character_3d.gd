class_name FloatingPlayerCharacter3D
extends PlayerCharacter3D

func _ready() -> void:
	super._ready()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	_mouse_rotation = global_basis.get_euler() * Vector3.UP
	interaction_ray.add_exception(self)

func _physics_process(delta: float) -> void:
	#_process_gravity(delta)
	_process_input(delta, speed, acceleration, deceleration)
	_process_velocity()

@onready var interaction_ray := %InteractionRay

func _input(event: InputEvent) -> void:
	super._input(event)
	if event.is_action(&"interact"):
		if interaction_ray.current_target:
			# TODO: HUD
			interaction_ray.begin_interaction()

func _unhandled_input(event: InputEvent) -> void:
	super._unhandled_input(event)
	_mouse_moving = event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED
	if _mouse_moving:
		var mouse_event = event as InputEventMouseMotion
		_input_yaw = -mouse_event.relative.x * mouse_sensitivity
		_input_pitch = -mouse_event.relative.y * mouse_sensitivity

#region Movement

@export_category("Movement")
@export var speed : float = 10.0
@export var acceleration : float = 20.0
@export var deceleration : float = 100.0

func _process_input(delta : float, desired_speed : float, acceleration_rate : float, deceleration_rate : float) -> void:
	#if not is_processing_input():
		#return
	
	# Get the input direction and handle the movement/deceleration.
	var input_dir := JamUtils.get_move_input_dir_3d()
	var direction := (transform.basis * input_dir).normalized()
	if direction:
		velocity = velocity.move_toward(direction * desired_speed, acceleration_rate * delta)
	else:
		velocity = velocity.move_toward(Vector3.ZERO, deceleration_rate * delta)

#endregion

#region Camera
# TODO: separate

@onready var CAMERA_CONTROLLER : Node3D = %CameraController
@onready var CAMERA : Camera3D = %Camera

const MIN_TILT = deg_to_rad(-90)
const MAX_TILT = deg_to_rad(90)

var _mouse_moving : bool = false
var _input_yaw : float
var _input_pitch : float
var _mouse_rotation : Vector3
var _player_rotation : Vector3
var _camera_rotation : Vector3
@export var mouse_sensitivity : float = 0.5

var _saved_yaw_input : float

func _process_camera(delta : float) -> void:
	_saved_yaw_input = _input_yaw
	_mouse_rotation.x += _input_pitch * delta
	_mouse_rotation.x = clamp(_mouse_rotation.x, MIN_TILT, MAX_TILT)
	_mouse_rotation.y += _input_yaw * delta
	
	_player_rotation = Vector3(0, _mouse_rotation.y, 0)
	_camera_rotation = Vector3(_mouse_rotation.x, 0, 0)
	
	CAMERA_CONTROLLER.transform.basis = Basis.from_euler(_camera_rotation)
	CAMERA_CONTROLLER.rotation.z = 0
	
	# TODO: revisit
	global_transform.basis = Basis.from_euler(_player_rotation)
	
	_input_pitch = 0
	_input_yaw = 0

#endregion
