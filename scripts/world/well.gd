extends Area2D

var _bodies_in := 0

@export_multiline() var dialogue := ""

func _ready() -> void:
	Signals.dialogue_branched.connect(_current_id)


func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("Interact") and _bodies_in > 0:
		if GameState.item_inventory.has(preload("res://assets/items/resources/coin.tres")):
			Signals.dialogue_started.emit(dialogue, "yes")
		else:
			Signals.dialogue_started.emit(dialogue, "no")


func _on_body_entered(body: Player) -> void:
		PlayerUi.label.show()
		_bodies_in += 1


func _on_body_exited(body: Player) -> void:
	_bodies_in -= 1
	if _bodies_in <= 0:
		PlayerUi.label.hide()

func _current_id(id: String) -> void:
	if id == "throw":
		GameState.remove_item(preload("res://assets/items/resources/coin.tres"))
