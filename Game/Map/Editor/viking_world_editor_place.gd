@tool
class_name VikingWorldEditorPlace
extends Node2D

func as_resource(pixels_per_unit : float = 10.0) -> VikingPlaceResource:
	var result = VikingPlaceResource.new()
	# TODO: persistent presets
	result.island = VikingIslandResource.new()
	result.island.scene = island_scene
	result.island.map_polygon = map_polygon.polygon
	result.heading = global_rotation
	result.coordinates = global_position / pixels_per_unit
	result.scale = maxf(scale.x, scale.y)
	return result

func from_resource(resource : VikingPlaceResource, pixels_per_unit : float = 10.0) -> void:
	island_scene = resource.island.scene
	map_polygon.polygon = resource.island.map_polygon
	global_rotation = resource.heading
	global_position = resource.coordinates * pixels_per_unit
	scale = Vector2.ONE * resource.scale

@export var island_scene : PackedScene
@onready var map_polygon: Polygon2D = %MapPolygon


func _ready() -> void:
	pass # Replace with function body.


func _process(delta: float) -> void:
	if Engine.is_editor_hint() and owner:
		owner.set_editable_instance(self, true)
