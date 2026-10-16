class_name TitleScene
extends Node

@export var main_menu_scene : PackedScene

func _ready() -> void:
	var main_menu := main_menu_scene.instantiate() as Control
	if main_menu:
		Game.canvas_manager.set_layer_content(JamUtils.layer_ui_menu, main_menu)
