extends Control


func _ready() -> void:
	visible = GameState.battled_npcs.is_empty()
