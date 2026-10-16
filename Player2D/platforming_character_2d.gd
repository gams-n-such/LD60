class_name PlatformingCharacter2D
extends PlayerCharacter2D


func _ready() -> void:
	super._ready()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _physics_process(delta: float) -> void:
	_process_gravity(delta)
	_process_input(delta, speed, acceleration, deceleration)
	_process_velocity()

@onready var interaction_area := %InteractionArea

func _input(event: InputEvent) -> void:
	super._input(event)
	if event.is_action(&"interact"):
		# TODO: HUD
		if interaction_area.current_target:
			interaction_area.begin_interaction()

func _unhandled_input(event: InputEvent) -> void:
	super._unhandled_input(event)

#region Movement

@export_category("Movement")
@export var speed : float = 300.0
@export var jump_velocity : float = 500.0
@export var acceleration : float = 1000.0
@export var deceleration : float = 2000.0

func _process_input(delta : float, desired_speed : float, acceleration_rate : float, deceleration_rate : float) -> void:
	# Handle jump.
	if Input.is_action_just_pressed(&"jump") and is_on_floor():
		velocity.y = -jump_velocity

	var input_dir := JamUtils.get_move_input_dir_2d()
	if input_dir:
		velocity.x = move_toward(velocity.x, input_dir.x * desired_speed, acceleration_rate * delta)
	else:
		velocity.x = move_toward(velocity.x, 0.0, deceleration_rate * delta)


#endregion
