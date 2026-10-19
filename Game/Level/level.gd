extends Node3D


@export var cycle_time_offset : float = -6.0
@onready var cycle_controller: CycleController = %CycleController



func _ready() -> void:
	Game.time_system.time_passed.connect(_on_time_passed)
	cycle_controller.set_time(Game.time_system.hour + cycle_time_offset)

func _on_time_passed(hours_delta : float):
	cycle_controller.advance_time(hours_delta)

func _process(delta: float) -> void:
	cycle_controller.advance_time(delta)
