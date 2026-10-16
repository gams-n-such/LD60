@tool
class_name NodeName2D
extends Label


func _ready() -> void:
	update_text()
	if Engine.is_editor_hint():
		if not get_parent().renamed.is_connected(update_text):
			get_parent().renamed.connect(update_text)

func update_text() -> void:
	if owner != self:
		text = get_parent().name
	else:
		text = name
