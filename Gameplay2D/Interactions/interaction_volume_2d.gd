class_name InteractionVolume2D
extends Area2D


@export var target : Node

func get_activatable() -> Activatable:
	return JamUtils.get_activatable_from(target)
