class_name VikingMapScreen
extends Control

@export var slide_in_duration : float = 0.8

func _ready() -> void:
	# Slide in
	position.y = size.y
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position:y", 0.0, slide_in_duration).set_trans(Tween.TRANS_SPRING).set_ease(Tween.EASE_OUT)
	grab_focus()


func _gui_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"ui_close_dialog") or event.is_action_pressed(&"show_map"):
		accept_event()
		# Slide out
		var tween = get_tree().create_tween()
		tween.tween_property(self, "position:y", size.y, slide_in_duration).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN)
		tween.tween_callback(queue_free)
		release_focus()
