class_name WebMouseCaptor
extends Node

@export var autopause_delay : float = 0.5
var _uncaptured_time : float = 0.0

func _ready() -> void:
	disable()

func enable() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

func disable() -> void:
	process_mode = Node.PROCESS_MODE_DISABLED

func _process(delta: float) -> void:
	if Input.mouse_mode != Input.MOUSE_MODE_CAPTURED and not get_tree().paused:
		_uncaptured_time += delta
		if _uncaptured_time > autopause_delay:
			_uncaptured_time = 0.0
			Game.open_pause_menu()
