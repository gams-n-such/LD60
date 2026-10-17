class_name SkipHoursSelector
extends Control

signal hours_changed(hours: int)

const MIN_HOURS: int = 1
const MAX_HOURS: int = 24

@export_range(MIN_HOURS, MAX_HOURS, 1)
var initial_hours: int = 1

@onready var hours_label: Label = %HoursLabel

var selected_hours: int = MIN_HOURS


func _ready() -> void:
	selected_hours = clampi(initial_hours, MIN_HOURS, MAX_HOURS)
	_update_label()

func _unhandled_key_input(event: InputEvent) -> void:
	if not visible:
		return

	if not event is InputEventKey:
		return

	if not event.pressed or event.echo:
		return

	match event.physical_keycode:
		KEY_D:
			increase_hours()
		KEY_A:
			decrease_hours()



func increase_hours() -> void:
	_set_hours(selected_hours + 1)


func decrease_hours() -> void:
	_set_hours(selected_hours - 1)


func get_selected_hours() -> int:
	return selected_hours


func _set_hours(value: int) -> void:
	var new_hours := clampi(value, MIN_HOURS, MAX_HOURS)

	if new_hours == selected_hours:
		return

	selected_hours = new_hours
	_update_label()
	hours_changed.emit(selected_hours)


func _update_label() -> void:
	if not is_node_ready():
		return

	hours_label.text = "%d %s" % [
		selected_hours,
		"hour" if selected_hours == 1 else "hours"
	]
