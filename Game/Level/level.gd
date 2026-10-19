extends Node3D


@export var cycle_time_offset : float = -6.0
@onready var cycle_controller: CycleController = %CycleController

var current_time : float:
	get:
		return fmod(24.0 + Game.time_system.hour + cycle_time_offset, 24.0)

func _ready() -> void:
	Game.time_system.time_changed.connect(_on_time_changed)
	cycle_controller.set_time(current_time)

func _on_time_changed(current_hour : float):
	cycle_controller.set_time(current_time)

func _process(delta: float) -> void:
	#Game.time_system.advance_time(delta)
	pass
