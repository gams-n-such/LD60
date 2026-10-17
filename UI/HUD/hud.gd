
extends Control

@onready var skip_hours_selector: SkipHoursSelector = %SkipHoursSelector


func _ready() -> void:
	skip_hours_selector.hide()


func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("timeskip"):
		skip_hours_selector.visible = not skip_hours_selector.visible
		Game.player.has_time_hud_open = not Game.player.has_time_hud_open
		get_viewport().set_input_as_handled()
	
	if event.is_action_pressed("ui_accept") :
		if skip_hours_selector.visible :
			var hours := skip_hours_selector.get_selected_hours()
			Game.skip_time(float(hours), true)
