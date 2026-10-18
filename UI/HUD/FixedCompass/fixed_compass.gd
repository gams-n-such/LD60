extends Control

@export var degrees_per_tick: int = 15
@export var pixels_per_degree: float = 3.0
@export var major_tick_interval: int = 45

@onready var tick_container: Control = %TickContainer
@onready var north_marker: TextureRect = %NorthMarker

const CARDINALS := {
	0: "N",
	45: "NE",
	90: "E",
	135: "SE",
	180: "S",
	225: "SW",
	270: "W",
	315: "NW",
}

var ticks: Array[Control] = []


func _ready() -> void:
	_create_ticks()
	_layout_ticks()


func _process(_delta: float) -> void:
	if Game.player == null:
		return

	var forward : Vector3 = -Game.player.global_basis.z
	var heading : float = fposmod(
		rad_to_deg(atan2(forward.x, -forward.z)),
		360.0
	)

	_layout_ticks(heading)


func _create_ticks() -> void:
	for tick in ticks:
		tick.queue_free()
	ticks.clear()

	# Extra ticks on both sides allow the strip to scroll smoothly.
	var count := ceili(size.x / pixels_per_degree / degrees_per_tick) + 4

	for i in range(-count, count + 1):
		var angle := posmod(i * degrees_per_tick, 360)
		var container := Control.new()
		container.name = "Tick%d" % i
		tick_container.add_child(container)

		var is_major := angle % major_tick_interval == 0
		var line := ColorRect.new()
		line.color = Color.WHITE
		line.size = Vector2(2, 16 if is_major else 8)
		line.position = Vector2(-1, 4)
		container.add_child(line)

		if is_major:
			var label := Label.new()
			label.text = CARDINALS.get(angle, str(angle))
			label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			label.position = Vector2(-24, 20)
			label.size = Vector2(48, 20)
			container.add_child(label)

		container.set_meta("angle", angle)
		container.set_meta("index", i)
		ticks.append(container)


func _layout_ticks(heading: float = 0.0) -> void:
	var center_x := size.x / 2.0
	var center_y := 0.0
	var north_x := center_x

	for tick in ticks:
		var angle: float = tick.get_meta("angle")

		var difference := fposmod(angle - heading + 180.0, 360.0) - 180.0

		var position_x := center_x + difference * pixels_per_degree

		tick.position = Vector2(position_x, center_y)
		tick.visible = abs(difference) < size.x / pixels_per_degree / 2.0 + degrees_per_tick
		
		if angle == 0:
			north_x = position_x
		north_marker.position.x = north_x - north_marker.size.x / 2.0 + 45.0
