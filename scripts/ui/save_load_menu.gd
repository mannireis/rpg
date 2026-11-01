extends PanelContainer

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
	for slots in slot_buttons.size():
		var slot := slots
		slot_buttons[slots].pressed.connect(_on_slot_pressed.bind(slot))
	for delete in delete_buttons.size():
		var slot := delete
		delete_buttons[delete].pressed.connect(_on_delete_pressed.bind(slot))


func _process(delta: float) -> void:
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
	SaveManager.delete_save(slot)


func _on_set_name_box_text_submitted(new_text: String) -> void:
	$SetNameBoxPanel.hide()
	if %SetNameBox.text.strip_edges() == "":
		GameState.player_name = "Emily"
	else:
		GameState.player_name = %SetNameBox.text
