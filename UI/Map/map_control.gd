extends Control

const MAP_ISLAND_CONTROL = preload("uid://dta16kwj7iqp8")

@onready var actual_map: Control = %ActualMap
@onready var islands_root: Control = %IslandsRoot

var map_center_px : Vector2:
	get:
		return actual_map.size / 2.0

var map_radius_px : float:
	get:
		return actual_map.size.x / 2.0

var pixels_per_unit : float:
	get:
		return map_radius_px / world_resource.radius

var world_resource : VikingWorldResource:
	get:
		return Game.world_resource

func _ready() -> void:
	if not world_resource:
		return
	
	await get_tree().create_timer(.01).timeout
	
	for place in world_resource.places:
		var island_control := MAP_ISLAND_CONTROL.instantiate() as MapIslandControl
		islands_root.add_child(island_control)
		island_control.from_resource(place.island, pixels_per_unit)
		print(map_center_px)
		island_control.position = map_center_px + place.coordinates * pixels_per_unit
		island_control.rotation = place.heading
		island_control.scale = place.scale_2d * pixels_per_unit



func _process(delta: float) -> void:
	pass
