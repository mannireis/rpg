extends Node2D


func _ready() -> void:
	$AnimatedSprite2D.play("idle")


func _on_pressure_plate_4_correct_password() -> void:
	print("Awarded")
	GameState.add_card(CardDatabase.db[4][0])
	$AnimatedSprite2D.play("destroy")
