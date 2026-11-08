extends Area2D

@export_multiline() var dialogue := ""

func _on_body_entered(body: Node2D) -> void:
	PlayerUi.label.show()
	Signals.dialogue_started.emit(dialogue, "start")
	GameState.add_item(preload("res://assets/items/resources/coin.tres"))


func _on_body_exited(body: Node2D) -> void:
	PlayerUi.label.hide()
