
extends Control

@onready var skip_hours_selector: SkipHoursSelector = %SkipHoursSelector


func _ready() -> void:
	skip_hours_selector.hide()


func _unhandled_key_input(event: InputEvent) -> void:
	if not event is InputEventKey:
		return

	if not event.pressed or event.echo:
		return

	if event.physical_keycode == KEY_T:
		skip_hours_selector.visible = not skip_hours_selector.visible
		Game.player.has_time_hud_open = not Game.player.has_time_hud_open
		get_viewport().set_input_as_handled()
		
	if event.physical_keycode == KEY_ENTER :
		if skip_hours_selector.visible :
			var hours := skip_hours_selector.get_selected_hours()
			Game.skip_time(float(hours), true)
