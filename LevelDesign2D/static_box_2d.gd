@tool
class_name StaticBox2D
extends StaticBody2D


func _ready() -> void:
	_update_size()
	_update_color()
	if Engine.is_editor_hint():
		EditorInterface.get_selection().selection_changed.connect(on_editor_selection_changed)
		on_editor_selection_changed()

var _shape_res : RectangleShape2D:
	get:
		return %Collision.shape

@onready var _color_rect := %ColorRect

var _size : Vector2 = Vector2.ONE * 100.0
@export_custom(PROPERTY_HINT_NONE, "suffix:px") var size : Vector2:
	get:
		return _size
	set(new_size):
		_size = new_size
		if is_inside_tree():
			_update_size()

func _update_size() -> void:
	_shape_res.size = size
	_color_rect.size = size
	_color_rect.position = -size / 2.0

var _color : Color = Color.GRAY
@export var color : Color:
	get:
		return _color
	set(new_color):
		_color = new_color
		if is_inside_tree():
			_update_color()

func _update_color() -> void:
	modulate = color

#region Tool

var was_selected : bool = false

func on_editor_selection_changed() -> void:
	var is_selected : bool = EditorInterface.get_selection().get_selected_nodes().has(self)
	if is_selected != was_selected:
		if not is_selected:
			consume_scale()
		was_selected = is_selected

func consume_scale() -> void:
	size = size * scale
	scale = Vector2.ONE

#endregion
