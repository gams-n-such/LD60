## super-early prototype of checkpoint system
## TODO: scene management
## TODO: connect to spawners and triggers
## TODO: checkpoint ordering
class_name Checkpoint
extends Node

signal restart_requested

## Check this for first checkpoint
@export var auto_activate : bool = false

func _ready() -> void:
	if auto_activate and Game.last_checkpoint == null:
		activate()

func activate() -> void:
	Game.last_checkpoint = self

func request_restart() -> void:
	restart_requested.emit()
