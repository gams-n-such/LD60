# Register this as a global autoload
extends Node

@export_flags_3d_render var default_camera_layers
@export_flags_3d_render var editor_camera_layers

func _ready() -> void:
	ship_state = ship_state_scene.instantiate() as VikingShipState
	add_child(ship_state)
	_create_fade_overlay()

func _create_fade_overlay() -> void:
	var fade_layer := CanvasLayer.new()
	fade_layer.name = "TimeSkipFade"
	fade_layer.layer = 110
	add_child(fade_layer)

	_fade_rect = ColorRect.new()
	_fade_rect.name = "FadeRect"
	_fade_rect.color = Color.BLACK
	_fade_rect.modulate.a = 0.0
	_fade_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_fade_rect.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	fade_layer.add_child(_fade_rect)

func _fade_to(alpha: float) -> void:
	var tween := create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(_fade_rect, "modulate:a", alpha, 1.0)
	await tween.finished


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("debug_exit"):
		quit_to_desktop()
	elif event.is_action_pressed("debug_mouse"):
		toggle_mouse_cursor()
	elif event.is_action_pressed("debug_dev_view"):
		toggle_dev_view()

func toggle_mouse_cursor() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED if Input.mouse_mode != Input.MOUSE_MODE_CAPTURED else Input.MOUSE_MODE_VISIBLE


#region Jam

@export var world_resource : VikingWorldResource

var ship_state : VikingShipState = null
var player : VikingCharacter3D = null

func skip_time(hours: float, fade: bool) -> void:
	if _is_skipping_time:
		return
	if hours < 0.0:
		push_warning("Cannot skip a non-positive number of hours.")
		return
	if not is_instance_valid(gameplay_level):
		push_error("Cannot skip time: no active VikingLevel registered.")
		return
	if world_resource == null:
		push_error("Cannot skip time: world_resource is not set.")
		return
	if fade:
		_is_skipping_time = true
		await _fade_to(1.0)
	ship_state.sail_forward(hours)
	gameplay_level.update_nearby_islands(
		world_resource,
		ship_state.map_position
	)
	if fade:
		await _fade_to(0.0)
		_is_skipping_time = false

#endregion

#region States

signal state_changed

@onready var game_state_machine: StateMachine = %GameStateMachine

func change_game_state(new_state_name : StringName) -> void:
	game_state_machine.request_transition_external(new_state_name)

func _on_game_state_changed(old_state: State, new_state: State) -> void:
	# TODO: add arguments
	state_changed.emit()

#endregion

#region Pause

var _active_pause_menu : Control

func open_pause_menu() -> void:
	assert(not _active_pause_menu)
	_active_pause_menu = pause_menu_scene.instantiate() as Control
	canvas_manager.push_content_to_layer(JamUtils.layer_ui_menu, _active_pause_menu)

func pause() -> void:
	get_tree().paused = true

func unpause() -> void:
	get_tree().paused = false

#endregion

#region Game

var last_checkpoint : Checkpoint = null

func restart_from_last_checkpoint() -> bool:
	if last_checkpoint:
		last_checkpoint.request_restart()
		return true
	else:
		return false

func clear_checkpoint() -> void:
	last_checkpoint = null

#endregion

#region Game Flow

var _fade_rect: ColorRect
var _is_skipping_time: bool = false

var gameplay_level: VikingLevel = null

func start_game() -> void:
	change_game_state(GameState.GAMEPLAY)

func restart_level() -> void:
	pre_level_change()
	get_tree().reload_current_scene()
	await get_tree().scene_changed
	post_level_change()

enum StageResult { IN_PROGRESS, LOOSE, WIN }
var stage_result : StageResult = StageResult.IN_PROGRESS

func win() -> void:
	#init_game_over(StageResult.WIN)
	change_game_state(GameState.VICTORY)

func loose() -> void:
	init_game_over(StageResult.LOOSE)

func quit_to_title() -> void:
	load_title_scene()

func quit_to_desktop() -> void:
	get_tree().quit()

#endregion

#region Game Over

var _active_game_over_screen : Control

func init_game_over(result : StageResult) -> void:
	assert(not _active_game_over_screen)
	stage_result = result
	_active_game_over_screen = game_over_scene.instantiate() as Control
	canvas_manager.push_content_to_layer(JamUtils.layer_ui_menu, _active_game_over_screen)

#endregion

#region Scenes

@export_category("Scenes")
@export var title_scene : PackedScene
@export var gameplay_scene : PackedScene
@export var pause_menu_scene : PackedScene
@export var game_over_scene : PackedScene

@export var ship_state_scene : PackedScene = null

func load_title_scene() -> void:
	load_level(title_scene)

func load_gameplay_scene() -> void:
	load_level(gameplay_scene)

func load_level(level_scene : PackedScene) -> void:
	if level_scene:
		pre_level_change()
		get_tree().change_scene_to_packed(level_scene)
		post_level_change()
	else:
		push_error("Trying to load empty level")

func pre_level_change() -> void:
	canvas_manager.clear_layer(JamUtils.layer_ui_menu)
	free_transient_scenes()

func post_level_change() -> void:
	pass

#endregion

#region UI

# TODO: this shall not work in split-scren = cannot make it an autoload
@onready var canvas_manager : CanvasManager = %CanvasManager

#endregion

#region Cameras

# TODO: Camera management
var cameras : Dictionary[TaggedCamera3D.Tag, TaggedCamera3D]

#endregion

#region Transients
# TODO: move to separate script
# TODO: support non-Node objects?

# These will be deleted when changing scenes
# TODO: optimize by making it a dictionary?
var transient_scenes : Array[Node]

func register_transient_scene(scene_instance : Node) -> void:
	assert(scene_instance)
	if not transient_scenes.has(scene_instance):
		transient_scenes.append(scene_instance)

func free_transient_scenes() -> void:
	for scene in transient_scenes:
		if is_instance_valid(scene):
			scene.queue_free()

#endregion

#region Dev View
# TODO: move to camera system

func toggle_dev_view() -> void:
	toggle_dev_view_3d()
	toggle_dev_view_2d()

func toggle_dev_view_3d() -> bool:
	var camera_3d := get_viewport().get_camera_3d()
	if camera_3d:
		if camera_3d.cull_mask & editor_camera_layers == 0:
			camera_3d.cull_mask |= editor_camera_layers
		else:
			camera_3d.cull_mask &= ~editor_camera_layers
		return true
	return false

func toggle_dev_view_2d() -> bool:
	if get_viewport().canvas_cull_mask & editor_camera_layers == 0:
		get_viewport().canvas_cull_mask |= editor_camera_layers
	else:
		get_viewport().canvas_cull_mask &= ~editor_camera_layers
	return true

#endregion
