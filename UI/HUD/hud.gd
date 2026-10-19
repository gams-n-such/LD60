
extends Control

@onready var skip_hours_selector: SkipHoursSelector = %SkipHoursSelector


func _ready() -> void:
	skip_hours_selector.hide()

const MAP_SCREEN = preload("uid://cy5lwcplhd74x")

func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("timeskip"):
		skip_hours_selector.visible = not skip_hours_selector.visible
		Game.player.has_time_hud_open = not Game.player.has_time_hud_open
		get_viewport().set_input_as_handled()
	
	if event.is_action_pressed("ui_accept") :
		if skip_hours_selector.visible :
			var hours := skip_hours_selector.get_selected_hours()
			Game.skip_time(float(hours), true)
	
	if event.is_action_pressed("show_map") :
		var map_screen := MAP_SCREEN.instantiate() as Control
		Game.canvas_manager.set_layer_content(JamUtils.layer_ui_info, map_screen)
		#Game.canvas_manager.push_content_to_layer(JamUtils.layer_ui_info, map_screen)
		AudioManager.play_sound_ui(AudioManager.global_sound.map_unfold, AudioManager.BusType.UI_BUS)
