extends Area2D

@export var connected_room: String
@export var player_pos: Vector2


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		RoomChangeGlobal.activate = true
		RoomChangeGlobal.player_pos = player_pos
		get_tree().call_deferred("change_scene_to_file", connected_room)
