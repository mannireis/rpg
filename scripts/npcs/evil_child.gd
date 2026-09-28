extends NPC
var battle_done: bool = false
func _ready():
	area2d.body_entered.disconnect(_on_area_2d_body_entered)
	area2d.body_entered.connect(start_battle)

func start_battle(body: Node2D):
	var p = get_tree().current_scene.scene_file_path
	if body.is_in_group("player") and p not in RoomChangeGlobal.scenes_battle_completed:
		RoomChangeGlobal.activate = true
		RoomChangeGlobal.player_pos = body.global_position
		RoomChangeGlobal.scene_return = p
		RoomChangeGlobal.scenes_battle_completed.append(p)
		battle_done = true
		get_tree().call_deferred("change_scene_to_file", "res://scenes/combat/battle.tscn")
