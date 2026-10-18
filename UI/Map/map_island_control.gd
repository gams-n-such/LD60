class_name MapIslandControl
extends Control

@onready var sprite: TextureRect = %Sprite
@onready var polygon: Polygon2D = %Polygon
@onready var name_label: Label = %NameLabel

func from_resource(resource : VikingIslandResource, pixels_per_unit : float = 10.0) -> void:
	name_label.text = resource.name
	if resource.map_sprite:
		sprite.texture = resource.map_sprite
		sprite.rotation = resource.map_sprite_rotation
		sprite.scale = resource.map_sprite_scale
		polygon.polygon = PackedVector2Array()
	else:
		sprite.texture = null
		polygon.polygon = resource.map_polygon
		polygon.scale = resource.map_polygon_scale * pixels_per_unit

func _ready() -> void:
	pass # Replace with function body.


func _process(delta: float) -> void:
	pass
