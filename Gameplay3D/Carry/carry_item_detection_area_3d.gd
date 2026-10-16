class_name CarryItemDetectionArea3D
extends Area3D

signal detected_items_changed

var detected_items : Array[Node3D]

func has_detected_items() -> bool:
	return not detected_items.is_empty()

func get_closest_item() -> Node3D:
	return JamUtils.get_closest_node_3d(global_position, detected_items)

func _on_body_entered(body: Node3D) -> void:
	if not detected_items.has(body):
		detected_items.append(body)
		detected_items_changed.emit()

func _on_body_exited(body: Node3D) -> void:
	if detected_items.has(body):
		detected_items.erase(body)
		detected_items_changed.emit()
