extends Node

var met_npcs: Dictionary = {}
var battle_running: bool = false
var player_pos: Vector2
var speaking_with: StringName

func meet(npc_id: StringName) -> void:
	met_npcs[npc_id] = true


func has_met(npc_id: StringName) -> bool:
	return met_npcs.has(npc_id)
