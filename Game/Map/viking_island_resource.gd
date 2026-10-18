@tool
class_name VikingIslandResource
extends Resource


@export var name : String
@export var scene : PackedScene

@export var map_polygon : PackedVector2Array
@export var map_polygon_scale : Vector2 = Vector2.ONE

@export var map_sprite : Texture2D = null
@export var map_sprite_rotation : float = 0.0
@export var map_sprite_scale : float = 1.0
