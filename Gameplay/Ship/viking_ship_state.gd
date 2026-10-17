class_name VikingShipState
extends Node

## Ship heading in degrees: 0 = north, 90 = east.
var heading: float = 0.0


func set_heading(value: float) -> void:
	heading = fposmod(value, 360.0)


func get_forward() -> Vector3:
	var radians := deg_to_rad(heading)
	return Vector3(
		sin(radians),
		0.0,
		-cos(radians)
	)
