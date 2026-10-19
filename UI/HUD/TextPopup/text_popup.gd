class_name TextPopup
extends CanvasLayer

@onready var panel: PanelContainer = %PanelContainer
@onready var rune_panel: PanelContainer = %RuneContainer
@onready var title_label: Label = %TitleLabel
@onready var description_label: Label = %DescriptionLabel
@onready var ok_button: Button = %OkButton
@onready var rune_texture: TextureRect = %RuneTexture

const FIRST_RUNE_ICON: Texture2D = preload("res://Game/Assets/icons/rune_1_001.png")
const SECOND_RUNE_ICON: Texture2D = preload("res://Game/Assets/icons/rune_2_001.png")
const THIRD_RUNE_ICON: Texture2D = preload("res://Game/Assets/icons/rune_3_001.png")

func _ready() -> void:
	layer = 100
	panel.hide()
	rune_panel.hide()
	ok_button.pressed.connect(_on_ok_pressed)
	if not Game.visiting_system.island_visited.is_connected(_on_island_visited):
		Game.visiting_system.island_visited.connect(_on_island_visited)

func _on_island_visited(place: VikingPlaceResource, quest: VikingQuestResource) -> void:
	if quest != null:
		print("Quest popup with header=%s, desc=%s" % [quest.header, quest.description])
		if quest.island_name == "SleipnirIsland" and !Game.quest_system.completed_loki_quest:
			description_label.text = "\"You place the runestones into the iron sockets on the horse's neck, and the ancient mechanisms inside begin to grind and creak. The air trembles, filled with magic. A thousand years of dust and rust fall from its mighty body, churning the sea around it into foam.

Odin's steel steed has awakened.

But just before departure, a thunderous crash erupts: Loki and Heimdall, sworn enemies, have clashed in battle. With a mighty blow, Heimdall knocks Loki off the steed, sending him plunging into the poisonous sea.

The god of lies will never return to the world of the living.\""
		else:
			description_label.text = quest.description
		title_label.text = quest.header
		if quest.description.contains("I'll give you the first rune."):
			rune_texture.texture = FIRST_RUNE_ICON
			rune_panel.show()
		if quest.description.contains("Here, take this rune."):
			rune_texture.texture = SECOND_RUNE_ICON
			rune_panel.show()
		if quest.description.contains("take the rune resting on the tip"):
			rune_texture.texture = THIRD_RUNE_ICON
			rune_panel.show()
	else:
		if place.description == null or place.description.is_empty():
			return
		if place.description_header == null or place.description_header.is_empty():
			if place.is_rune():
				title_label.text = place.rune.name
			if place.is_island():
				title_label.text = place.island.name
		else:
			title_label.text = place.description_header
		description_label.text = place.description
	Game.pause()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	panel.show()
	ok_button.grab_focus()

func _on_ok_pressed() -> void:
	Game.unpause()
	rune_panel.hide()
	panel.hide()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
