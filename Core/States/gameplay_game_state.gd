class_name GameplayGameState
extends GameState

@export var countdown_scene : PackedScene
@export var mouse_captor : WebMouseCaptor

func enter(prev_state : State) -> void:
	super.enter(prev_state)
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	_show_hud()
	
	Game.load_gameplay_scene()
	
	if countdown_scene:
		var countdown := countdown_scene.instantiate() as Control
		Game.canvas_manager.push_content_to_layer(JamUtils.layer_ui_menu, countdown)
		await countdown.tree_exited
	
	if mouse_captor:
		mouse_captor.enable()

func exit(next_state : State) -> void:
	_hide_hud()
	Game.canvas_manager.clear_layer(JamUtils.layer_ui_post_process)
	if mouse_captor:
		mouse_captor.disable()
	super.exit(next_state)

func update(delta: float) -> void:
	super.update(delta)

func physics_update(delta: float) -> void:
	super.physics_update(delta)

#region HUD

@export var hud_scene : PackedScene

func _show_hud() -> void:
	if hud_scene:
		var hud := hud_scene.instantiate() as Control
		Game.canvas_manager.set_layer_content(JamUtils.layer_ui_hud, hud)

func _hide_hud() -> void:
	Game.canvas_manager.clear_layer(JamUtils.layer_ui_hud)

#endregion
