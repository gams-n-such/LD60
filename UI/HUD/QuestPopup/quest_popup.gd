
class_name QuestPopup
extends CanvasLayer

@onready var panel: PanelContainer = %PanelContainer
@onready var title_label: Label = %TitleLabel
@onready var description_label: Label = %DescriptionLabel
@onready var ok_button: Button = %OkButton


func _ready() -> void:
	layer = 100
	panel.hide()
	ok_button.pressed.connect(_on_ok_pressed)
	if not Game.quest_system.quest_completed.is_connected(_on_quest_completed):
		Game.quest_system.quest_completed.connect(_on_quest_completed)

func _on_quest_completed(quest: VikingQuestResource) -> void:
	title_label.text = "QUEST COMPLETED"
	description_label.text = quest.description
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	panel.show()
	ok_button.grab_focus()

func _on_ok_pressed() -> void:
	panel.hide()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
