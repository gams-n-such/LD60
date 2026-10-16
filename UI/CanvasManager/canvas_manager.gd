class_name CanvasManager
extends Node

var layers : Dictionary[StringName, CanvasLayer] = {}

func _ready() -> void:
	for child in get_children():
		if child is CanvasLayer:
			layers[child.name] = child
		else:
			push_warning("Child node %s is incompatible with Canvas Manager %s" % [child.name, get_path()])
	Game.canvas_manager = self

func push_content_to_layer(layer : StringName, content : Control) -> void:
	var layer_node := _get_layer(layer)
	if layer_node:
		_push_content_to_layer(layer_node, content)

func set_layer_content(layer : StringName, content : Control) -> void:
	var layer_node := _get_layer(layer)
	if layer_node:
		_clear_layer(layer_node)
		_push_content_to_layer(layer_node, content)

func clear_layer(layer : StringName) -> void:
	var layer_node := _get_layer(layer)
	if layer_node:
		_clear_layer(layer_node)

func _push_content_to_layer(layer : CanvasLayer, content : CanvasItem) -> void:
	assert(content)
	assert(not content.is_inside_tree())
	layer.add_child(content)

func _get_layer(layer : StringName) -> CanvasLayer:
	var layer_node : CanvasLayer = layers.get(layer)
	if layer_node == null:
		push_error("Canvas Layer %s not found on Canvas Manager %s" % [layer, get_path()])
	return layer_node

func _clear_layer(layer : CanvasLayer) -> void:
	if layer:
		for child in layer.get_children():
			child.queue_free()
