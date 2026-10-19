class_name VikingTimeSystem
extends Node

signal time_changed(current_hour : float)
signal time_passed(hours_passed : float)

@export var hour : float = 12.0

func _ready() -> void:
	pass # Replace with function body.

func advance_time(delta_hours : float) -> void:
	hour = fmod(hour + delta_hours, 24.0)
	time_changed.emit(hour)
	time_passed.emit(delta_hours)
