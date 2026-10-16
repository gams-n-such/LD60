extends Button

@export var scene_to_load : PackedScene 

func _pressed() -> void:
	assert(scene_to_load)
	Game.load_level(scene_to_load)
