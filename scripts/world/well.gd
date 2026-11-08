extends Area2D

@export_multiline() var dialogue := ""

var _player_in_range := false


func _ready() -> void:
	Signals.dialogue_branched.connect(_on_dialogue_branched)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"Interact") and _player_in_range:
		if GameState.item_inventory.has(preload("res://assets/items/resources/coin.tres")):
			Signals.dialogue_started.emit(dialogue, &"has_coin_true")
		else:
			Signals.dialogue_started.emit(dialogue, &"has_coin_false")


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		_player_in_range = true
		PlayerUi.label.show()


func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		_player_in_range = false
		PlayerUi.label.hide()


func _on_dialogue_branched(to: StringName) -> void:
	match to:
		&"throw_coin":
			GameState.remove_item(preload("res://assets/items/resources/coin.tres"))

		&"grant_wish":
			get_tree().current_scene.fade_canvas($Marker2D.global_position)
