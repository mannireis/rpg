extends Node

signal battle_won
signal battle_lost
signal start_battle
func _start_battle() -> void:
	var p = get_tree().current_scene.scene_file_path
	if GameState.battled_npcs.get(GameState.speaking_with) == null:
		RoomChangeGlobal.activate = true
		RoomChangeGlobal.player_pos = GameState.player_pos
		RoomChangeGlobal.scene_return = p
		GameState.battle_running = true
		get_tree().call_deferred("change_scene_to_file", "res://scenes/combat/battle.tscn")
	else: print(GameState.battled_npcs)
	
func _ready() -> void: start_battle.connect(_start_battle)
