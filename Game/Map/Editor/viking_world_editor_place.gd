@tool
class_name VikingWorldEditorPlace
extends Node2D

func as_resource(pixels_per_unit : float = 10.0) -> VikingPlaceResource:
	var result = VikingPlaceResource.new()
	# TODO: persistent presets
	result.island = VikingIslandResource.new()
	result.island.name = name_label.text
	result.island.scene = island_scene
	result.island.map_sprite = map_sprite.texture
	result.island.map_sprite_rotation = map_sprite.rotation
	result.island.map_sprite_scale = map_sprite.scale
	result.island.map_polygon = map_polygon.polygon
	result.island.map_polygon_scale = map_polygon.scale
	result.heading = global_rotation
	result.coordinates = global_position / pixels_per_unit
	result.scale = scale / pixels_per_unit
	return result

func from_resource(resource : VikingPlaceResource, pixels_per_unit : float = 10.0) -> void:
	name_label.text = resource.island.name
	island_scene = resource.island.scene
	if resource.island.map_sprite:
		map_sprite.texture = resource.island.map_sprite
		map_sprite.rotation = resource.island.map_sprite_rotation
		map_sprite.scale = resource.island.map_sprite_scale
		map_polygon.polygon = PackedVector2Array()
	else:
		map_sprite.texture = null
		map_polygon.polygon = resource.island.map_polygon
		map_polygon.scale = resource.island.map_polygon_scale
	global_rotation = resource.heading
	global_position = resource.coordinates * pixels_per_unit
	scale = resource.scale * pixels_per_unit

@export var island_scene : PackedScene
@onready var map_polygon: Polygon2D = %MapPolygon
@onready var map_sprite: Sprite2D = %MapSprite
@onready var name_label: Label = %NameLabel


func _ready() -> void:
	if Engine.is_editor_hint() and owner:
		owner.set_editable_instance(self, true)
