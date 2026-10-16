@abstract class_name PlayerCharacter3D
extends CharacterBody3D

func _ready() -> void:
	_show_hud()

func _exit_tree() -> void:
	_hide_hud()

func _process(delta: float) -> void:
	_process_camera(delta)

func _physics_process(delta: float) -> void:
	_process_gravity(delta)
	#_process_input(SPEED, ACCELERATION, DECELERATION)
	_process_velocity()

func _input(event: InputEvent) -> void:
	# For easier overriding
	pass

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		Game.open_pause_menu()

#region HUD

@export var hud_scene : PackedScene

func _show_hud() -> void:
	if hud_scene:
		var hud := hud_scene.instantiate() as Control
		Game.canvas_manager.set_layer_content(JamUtils.layer_ui_hud, hud)

func _hide_hud() -> void:
	Game.canvas_manager.clear_layer(JamUtils.layer_ui_hud)

#endregion

#region Camera

# TODO: separate camera to a different scene?
@abstract func _process_camera(delta : float) -> void

#endregion

#region Movement

func _process_gravity(delta : float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

@abstract func _process_input(delta : float, speed : float, acceleration : float, deceleration : float) -> void

func _process_velocity() -> void:
	move_and_slide()

#endregion
