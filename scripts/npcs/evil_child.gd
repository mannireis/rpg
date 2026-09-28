extends NPC

var battle_done: bool = false

func start_battle(body: Node2D):
	var p = get_tree().current_scene.scene_file_path
	if p not in RoomChangeGlobal.scenes_battle_completed:
		RoomChangeGlobal.activate = true
		RoomChangeGlobal.player_pos = body.global_position
		RoomChangeGlobal.scene_return = p
		RoomChangeGlobal.scenes_battle_completed.append(p)
		battle_done = true
		get_tree().call_deferred("change_scene_to_file", "res://scenes/combat/battle.tscn")


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		start_battle(body)
