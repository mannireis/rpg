extends Node2D

var collected := false


func _ready() -> void:
	add_to_group("saveable")
	$AnimatedSprite2D.play("idle")


func save_id() -> String:
	return String("pedestal")


func save_state() -> Dictionary:
	return {"collected": collected}


func apply_state(state: Dictionary) -> void:
	collected = state.get("collected", false)
	if collected:
		$AnimatedSprite2D.play("destroy")


func _on_pressure_plate_4_correct_password() -> void:
	if collected:
		return
	print("Awarded")
	GameState.add_card(CardDatabase.db[4][0])
	collected = true
	$AnimatedSprite2D.play("destroy")
