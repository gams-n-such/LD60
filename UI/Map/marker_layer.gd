class_name VikingMarkerLayer
extends Control

const MARK_TEXTURE = preload("uid://cadtuvjiw4ub1")
@onready var distance_label: Label = $DistanceLabel
@onready var direction_label: Label = $DirectionLabel

var PX_TO_HOURS: float = 0.24
var marks: Array[Sprite2D] = []
var lines: Array[Line2D] = []

func _ready() -> void:
	grab_focus(true)

func _process(_delta: float) -> void:
	
	distance_label.visible = false
	direction_label.visible = false
	
	if marks.size() > 0 :
		var last_mark = marks[marks.size()-1]  
		var dist = last_mark.global_position.distance_to(get_global_mouse_position())
		distance_label.visible = true
		direction_label.visible = true
		distance_label.global_position = get_global_mouse_position() + Vector2(16, 16)
		direction_label.global_position = get_global_mouse_position() + Vector2(16, 0)
		distance_label.text = "%d hours" % int(dist * PX_TO_HOURS)
		direction_label.text = "%s" % get_compass_direction(last_mark.global_position, get_global_mouse_position())
		queue_redraw()


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			var local_pos = get_local_mouse_position()
			var world_pos = get_global_mouse_position()
			
			if marks.size() > 0 :
				var last_mark = marks[marks.size()-1]
				if last_mark != null and is_point_inside_sprite(world_pos, last_mark):
					marks.remove_at(marks.size()-1)
					last_mark.queue_free()
					last_mark = null
					lines[lines.size()-1].queue_free()
					lines.remove_at(lines.size()-1)
					return
				
			place_mark(local_pos)
			draw_coal_line(local_pos)

func place_mark(world_pos: Vector2) -> void:
	var mark = Sprite2D.new()
	mark.texture = MARK_TEXTURE
	mark.global_position = world_pos
	mark.scale = Vector2(0.5, 0.5)
	marks.append(mark)
	add_child(mark)
	AudioManager.play_sound_ui(AudioManager.global_sound.map_mark, AudioManager.BusType.UI_BUS)
	
func is_point_inside_sprite(point: Vector2, sprite: Sprite2D) -> bool:
	var local_rect = sprite.get_rect()
	var local_point = sprite.to_local(point)
	return local_rect.has_point(local_point)
	
func draw_coal_line(to: Vector2) -> void:
	if marks.size() > 0 :
		var line = Line2D.new()
		line.add_point(marks[marks.size()-1].position)
		line.add_point(to)
		line.width = 5.0
		line.default_color = Color(0.1, 0.1, 0.1)
		lines.append(line)
		add_child(line)
	
func _draw() -> void:
	if marks.size() > 0 :
		var last_mark = marks[marks.size()-1] 
		draw_line(last_mark.position, get_local_mouse_position() , Color(0.1, 0.1, 0.1) , 2)
		
func get_compass_direction(from: Vector2, to: Vector2) -> String:
	var delta = to - from
	if delta.length() < 1.0:
		return ""
	var dx = delta.x
	var dy = delta.y
	var abs_x = abs(dx)
	var abs_y = abs(dy)

	var diagonal_threshold = 0.5  

	if abs_y > abs_x * (1.0 / diagonal_threshold):
		return "N" if dy < 0 else "S"
	elif abs_x > abs_y * (1.0 / diagonal_threshold):
		return "E" if dx > 0 else "W"
	else:
		var ns = "N" if dy < 0 else "S"
		var ew = "E" if dx > 0 else "W"
		return ns + ew  
