extends Control

func _ready() -> void:
	if GameState.battled_npcs == {}:
		show()
	else:
		hide()
