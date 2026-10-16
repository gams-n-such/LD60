@abstract
class_name Effector
extends Node

@abstract func apply_effect(target: Node) -> bool

@abstract func remove_effect(target: Node) -> bool

@export var monitor_parent_area : bool = true

var _parent_area_2d : Area2D:
	get:
		return get_parent() as Area2D

var _parent_area_3d : Area3D:
	get:
		return get_parent() as Area3D

func _ready() -> void:
	if monitor_parent_area:
		if _parent_area_3d:
			_parent_area_3d.body_entered.connect(_on_area_3d_body_entered)
			_parent_area_3d.body_exited.connect(_on_area_3d_body_exited)
		elif _parent_area_2d:
			_parent_area_2d.body_entered.connect(_on_area_3d_body_entered)
			_parent_area_2d.body_exited.connect(_on_area_3d_body_exited)

func _exit_tree() -> void:
	if monitor_parent_area:
		if _parent_area_3d:
			_parent_area_3d.body_entered.disconnect(_on_area_3d_body_entered)
			_parent_area_3d.body_exited.disconnect(_on_area_3d_body_exited)
		elif _parent_area_2d:
			_parent_area_2d.body_entered.disconnect(_on_area_3d_body_entered)
			_parent_area_2d.body_exited.disconnect(_on_area_3d_body_exited)

func _on_area_3d_body_entered(body: Node3D) -> void:
	if apply_effect(body):
		print("%s applied effect to %s" % [self.name, body.name])

func _on_area_2d_body_entered(body: Node2D) -> void:
	if apply_effect(body):
		print("%s applied effect to %s" % [self.name, body.name])

func _on_area_3d_body_exited(body: Node3D) -> void:
	if remove_effect(body):
		print("%s removed effect from %s" % [self.name, body.name])

func _on_area_2d_body_exited(body: Node2D) -> void:
	if remove_effect(body):
		print("%s removed effect from %s" % [self.name, body.name])
