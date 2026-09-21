extends Node

var met_npcs: Dictionary = {}


func meet(npc_id: StringName) -> void:
	met_npcs[npc_id] = true


func has_met(npc_id: StringName) -> bool:
	return met_npcs.has(npc_id)
