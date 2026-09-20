extends CharacterBody2D


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		DialogueManager.start("res://assets/dialogue/john/john_start.txt")
