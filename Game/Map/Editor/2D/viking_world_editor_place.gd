@tool
class_name VikingWorldEditorPlace
extends Node2D

func as_resource(pixels_per_unit : float = 10.0) -> VikingPlaceResource:
	var result = VikingPlaceResource.new()
	# TODO: persistent presets
	result.island = generate_island_resource()
	result.rune = generate_rune_resource()
	result.heading = global_rotation
	result.coordinates = global_position / pixels_per_unit
	result.scale = scale / pixels_per_unit
	return result

func generate_island_resource() -> VikingIslandResource:
	if not is_island():
		return null
	var result = VikingIslandResource.new()
	result.name = name_label.text
	result.scene = place_scene
	result.map_sprite = map_sprite.texture
	result.map_sprite_rotation = map_sprite.rotation
	result.map_sprite_scale = map_sprite.scale
	#result.map_polygon = map_polygon.polygon
	#result.map_polygon_scale = map_polygon.scale
	return result

func generate_rune_resource() -> VikingRuneResource:
	if not is_rune():
		return null
	var result = VikingRuneResource.new()
	result.name = name_label.text
	result.scene = place_scene
	result.sprite = map_sprite.texture
	return result

func from_resource(resource : VikingPlaceResource, pixels_per_unit : float = 10.0) -> void:
	name_label.text = resource.island.name
	place_scene = resource.island.scene
	if resource.island.map_sprite:
		map_sprite.texture = resource.island.map_sprite
		map_sprite.rotation = resource.island.map_sprite_rotation
		#map_sprite.scale = resource.island.map_sprite_scale
		map_polygon.polygon = PackedVector2Array()
	else:
		map_sprite.texture = null
		#map_polygon.polygon = resource.island.map_polygon
		#map_polygon.scale = resource.island.map_polygon_scale
	global_rotation = resource.heading
	global_position = resource.coordinates * pixels_per_unit
	#scale = resource.scale * pixels_per_unit

func apply_island_resource(resource : VikingIslandResource) -> void:
	if not resource:
		return
	type = Type.ISLAND
	name_label.text = resource.name
	place_scene = resource.scene
	map_sprite.texture = resource.map_sprite
	map_sprite.rotation = resource.map_sprite_rotation
	#map_sprite.scale = resource.map_sprite_scale
	#map_polygon.polygon = resource.map_polygon
	#map_polygon.scale = resource.map_polygon_scale

func apply_rune_resource(resource : VikingRuneResource) -> void:
	if not resource:
		return
	type = Type.RUNE
	name_label.text = resource.name
	place_scene = resource.scene
	map_sprite.texture = resource.sprite

enum Type { ISLAND, RUNE }
@export var type : Type = Type.ISLAND:
	get:
		return type
	set(new_type):
		type = new_type
		map_polygon.visible = type == Type.ISLAND
		name_label.visible = type == Type.ISLAND

@export var place_scene : PackedScene
@onready var map_polygon: Polygon2D = %MapPolygon
@onready var map_sprite: Sprite2D = %MapSprite
@onready var name_label: Label = %NameLabel


func _ready() -> void:
	if Engine.is_editor_hint() and owner:
		owner.set_editable_instance(self, true)

func is_island() -> bool:
	return type == Type.ISLAND

func is_rune() -> bool:
	return type == Type.RUNE
