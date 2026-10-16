class_name Door
extends Node

func _ready() -> void:
	match state:
		DoorState.OPEN:
			open_instant()
		DoorState.CLOSED:
			close_instant()

#region Door
@export_group("Door", "")

enum DoorState { OPEN, CLOSED }

signal state_changed(door : Door, new_state : DoorState)

@export var state : DoorState = DoorState.CLOSED:
	get:
		return state
	set(new_state):
		state = new_state
		print("Door %s is now %s" % [name, str(new_state)])
		state_changed.emit(self, state)

signal progress_changed(progress : float)

var _progress : float = 0.0
@export_custom(PROPERTY_HINT_NONE, "", PROPERTY_USAGE_EDITOR | PROPERTY_USAGE_READ_ONLY) var open_progress : float:
	get:
		return _progress
	set(new_progress):
		_progress = new_progress
		progress_changed.emit(_progress)

func open_instant() -> bool:
	if is_fully_open():
		return false
	else:
		open_progress = 1.0
		state = DoorState.OPEN
		return true

func close_instant() -> bool:
	if is_fully_closed():
		return false
	else:
		open_progress = 0.0
		state = DoorState.CLOSED
		return true

func is_fully_open() -> bool:
	return open_progress >= 1.0

func is_fully_closed() -> bool:
	return open_progress <= 0.0

func toggle_state() -> void:
	if state == DoorState.OPEN:
		start_closing()
	elif state == DoorState.CLOSED:
		start_opening()

#endregion

#region Animation
@export_group("Animation", "")
@onready var animation_player: AnimationPlayer = %AnimationPlayer

var _current_anim_time : float:
	get:
		return animation_player.current_animation_position

# Add more types for specific projects, e.g., "heavy" doors for big stone gates
enum DoorAnimationType {
	DEFAULT
}
var open_anim_by_type : Dictionary[DoorAnimationType, StringName] = {
	DoorAnimationType.DEFAULT : &"default"
}

@export var animation_type : DoorAnimationType = DoorAnimationType.DEFAULT
@export var animation_time : float = 1.0
var animation_speed : float:
	get:
		if animation_time > 0.0:
			return 1.0 / animation_time
		else:
			return 100.0

func is_instant() -> bool:
	return animation_time <= 0.0

var _animation_name : StringName:
	get:
		return open_anim_by_type[animation_type]

func is_animating() -> bool:
	return animation_player.is_animation_active() and animation_player.is_playing()

func is_opening() -> bool:
	return animation_player.is_animation_active() and animation_player.get_playing_speed() > 0

func is_closing() -> bool:
	return animation_player.is_animation_active() and animation_player.get_playing_speed() < 0

func start_opening() -> bool:
	if is_opening() or is_fully_open():
		return false
	if is_instant():
		return open_instant()
	if is_animating():
		animation_player.play_section(_animation_name, _current_anim_time, -1, animation_speed)
	else:
		animation_player.play(_animation_name, -1, animation_speed, false)
	return true

func start_closing() -> bool:
	if is_closing() or is_fully_closed():
		return false
	if is_instant():
		return close_instant()
	if is_animating():
		animation_player.play_section(_animation_name, -1, _current_anim_time, -animation_speed, true)
	else:
		animation_player.play(_animation_name, -1, -animation_speed, true)
	return true

#endregion
