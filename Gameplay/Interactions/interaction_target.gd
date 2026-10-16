extends Node


@export var starting_state : Door.DoorState = Door.DoorState.CLOSED:
	get:
		return door_logic.state
	set(new_state):
		door_logic.state = new_state

@export var activatable: Activatable = null
@export var door_logic: Door = null

func _ready() -> void:
	pass

func get_activatable() -> Activatable:
	return activatable
