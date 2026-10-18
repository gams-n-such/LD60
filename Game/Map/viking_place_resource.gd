@tool
class_name VikingPlaceResource
extends Resource

@export var island : VikingIslandResource
@export var rune : VikingRuneResource
@export var coordinates : Vector2 = Vector2.ZERO
@export var heading : float = 0.0
@export var scale : Vector2 = Vector2.ONE
@export var visibility_range : float = 5.0
@export var acquisition_range : float = 5.0


func is_island() -> bool:
	assert((island != null) != (rune != null))
	return island != null

func is_rune() -> bool:
	assert((island != null) != (rune != null))
	return rune != null
