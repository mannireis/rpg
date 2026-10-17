extends Node2D


func _on_pressure_plate_correct_password() -> void:
	GameState.add_card(CardDatabase.db[4][0])
