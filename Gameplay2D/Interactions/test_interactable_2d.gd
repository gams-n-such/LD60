extends Node2D


@onready var logic: Activatable = %Logic

func get_activatable() -> Activatable:
	return logic

func _on_logic_activation_complete(object: Activatable, actor: Node) -> void:
	test()

@onready var sprite_2d: Sprite2D = $Sprite2D

func test() -> void:
	sprite_2d.self_modulate = JamUtils.get_random_color()
