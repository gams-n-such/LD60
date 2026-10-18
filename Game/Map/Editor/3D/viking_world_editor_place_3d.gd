@tool
class_name VikingWorldEditorPlace3D
extends Node3D

func _ready() -> void:
	if Engine.is_editor_hint() and owner:
		_respawn_editor_scene()
		owner.set_editable_instance(self, true)

enum Type { ISLAND, RUNE }
@export var type : Type = Type.ISLAND:
	get:
		return type
	set(new_type):
		type = new_type

func is_island() -> bool:
	return type == Type.ISLAND

func is_rune() -> bool:
	return type == Type.RUNE

var _spawned_editor_island : Node = null
@export var place_scene : PackedScene:
	set(new_scene):
		place_scene = new_scene
		if is_inside_tree() and Engine.is_editor_hint():
			_respawn_editor_scene()

func _respawn_editor_scene() -> void:
	if _spawned_editor_island:
		remove_child(_spawned_editor_island)
		_spawned_editor_island.queue_free()
		_spawned_editor_island = null
	if place_scene:
		_spawned_editor_island = place_scene.instantiate()
		add_child(_spawned_editor_island)
		_spawned_editor_island.owner = self

@export var map_icon: Texture2D
@export_custom(PROPERTY_HINT_NONE, "") var map_icon_rotation: float = 0.0
@export var map_icon_scale: float = 1.0
@onready var visibility_sphere: CSGSphere3D = %VisibilitySphere


func as_resource(map_scale : float = 1.0) -> VikingPlaceResource:
	var result = VikingPlaceResource.new()
	# TODO: persistent presets
	result.island = generate_island_resource()
	result.rune = generate_rune_resource()
	result.heading = global_rotation.y
	result.coordinates = Vector2(global_position.x, global_position.z) / map_scale
	result.scale = (_spawned_editor_island if _spawned_editor_island else self).scale / map_scale
	result.visibility_range = visibility_sphere.radius * maxf(scale.x, scale.z) / map_scale
	return result

func generate_island_resource() -> VikingIslandResource:
	if not is_island():
		return null
	var result = VikingIslandResource.new()
	result.name = name
	result.scene = place_scene
	result.map_sprite = map_icon
	result.map_sprite_rotation = map_icon_rotation
	result.map_sprite_scale = map_icon_scale
	return result

func generate_rune_resource() -> VikingRuneResource:
	if not is_rune():
		return null
	var result = VikingRuneResource.new()
	result.name = name
	result.scene = place_scene
	result.sprite = map_icon
	return result

func from_resource(resource : VikingPlaceResource, map_scale : float = 1.0) -> void:
	place_scene = resource.island.scene if resource.island else null
	apply_island_resource(resource.island)
	apply_rune_resource(resource.rune)
	global_position = Vector3(resource.coordinates.x, 0.0, resource.coordinates.y) * map_scale
	global_rotation = Vector3.UP * resource.heading
	(_spawned_editor_island if _spawned_editor_island else self).scale = resource.scale * map_scale
	visibility_sphere.radius = resource.visibility_range / maxf(scale.x, scale.z) * map_scale

func apply_island_resource(resource : VikingIslandResource) -> void:
	if not resource:
		return
	type = Type.ISLAND
	name = resource.name
	place_scene = resource.scene
	map_icon = resource.map_sprite
	map_icon_rotation = resource.map_sprite_rotation
	map_icon_scale = resource.map_sprite_scale

func apply_rune_resource(resource : VikingRuneResource) -> void:
	if not resource:
		return
	type = Type.RUNE
	name = resource.name
	place_scene = resource.scene
	map_icon = resource.sprite
