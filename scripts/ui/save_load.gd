extends PanelContainer

@onready var back_button: TextureButton = $MarginContainer/BackButton
@onready var delete_buttons: Array[Button] = [
	%DeleteButton,
	%DeleteButton2,
	%DeleteButton3,
	%DeleteButton4
]
@onready var slot_buttons: Array[Button] = [
	%LoadButton,
	%LoadButton2,
	%LoadButton3,
	%LoadButton4,
]

var _player_name: String = "Emily"

func _ready() -> void:
	back_button.mouse_entered.connect(_play_audio)
	for slots in slot_buttons.size():
		var slot := slots
		slot_buttons[slots].mouse_entered.connect(_play_audio)
		slot_buttons[slots].refresh(slot)
		slot_buttons[slots].pressed.connect(_on_slot_pressed.bind(slot))
	for delete in delete_buttons.size():
		var slot := delete
		delete_buttons[delete].mouse_entered.connect(_play_audio)
		delete_buttons[delete].pressed.connect(_on_delete_pressed.bind(slot))


func _process(_delta: float) -> void:
	for b in slot_buttons + delete_buttons:
		b.offset_transform_position = (
			Vector2.ONE if b.is_hovered()
			else Vector2.ZERO
			)


func _on_slot_pressed(slot: int) -> void:
	if not SaveManager.has_save(slot):
		$SetNameBoxPanel.show()
		await %SetNameBox.text_submitted
		GameState.current_slot = slot
		SaveManager.load_game(slot)
	else:
		SaveManager.load_game(slot)


func _on_delete_pressed(slot: int) -> void:
	for slots in slot_buttons.size():
		slot_buttons[slots].refresh(slot)
	SaveManager.delete_save(slot)


func _on_set_name_box_text_submitted(_new_text: String) -> void:
	$SetNameBoxPanel.hide()
	if %SetNameBox.text.strip_edges() == "":
		GameState.player_name = "Emily"
	else:
		GameState.player_name = %SetNameBox.text
	for slots in slot_buttons.size():
		slot_buttons[slots].refresh(slots)


func _refresh_button(button: Button, slot: int) -> void:
	button.refresh(slot)

func _play_audio() -> void:
	$AudioStreamPlayer.pitch_scale = randf_range(0.9, 1.1)
	$AudioStreamPlayer.play()


func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn")
