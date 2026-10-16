class_name InteractVolume3D
extends Area3D


@export var target : Node

func get_activatable() -> Activatable:
	return JamUtils.get_activatable_from(target)
