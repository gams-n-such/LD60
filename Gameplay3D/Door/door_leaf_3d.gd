class_name DoorLeaf3D
extends Node3D


@export var logic : Door = null
@export var door_leaf : Node3D = null
@export var open : Node3D = null
@export var closed : Node3D = null


func _ready() -> void:
	if logic:
		logic.progress_changed.connect(_on_door_open_progress_changed)
		_on_door_open_progress_changed(logic.open_progress)

func _exit_tree() -> void:
	if logic:
		logic.progress_changed.disconnect(_on_door_open_progress_changed)

func _on_door_open_progress_changed(progress : float) -> void:
	door_leaf.global_transform = lerp(closed.global_transform, open.global_transform, progress)
