extends Node

var met_npcs: Dictionary = {}
var battled_npcs: Dictionary = {}
var defeated_npcs: Dictionary[StringName,int] = {}
var battle_running: bool = false
var player_pos: Vector2
var speaking_with: StringName
var player_battle_inventory: Signals.BattleInv


func _ready() -> void:
	player_battle_inventory = PlayerCtl.starter_deck()


func meet(npc_id: StringName) -> void:
	met_npcs[npc_id] = true


func has_met(npc_id: StringName) -> bool:
	return met_npcs.has(npc_id)


func fought(npc_id: StringName, won: bool) -> void:
	if !battled_npcs.has(npc_id): battled_npcs[npc_id] = 0
	battled_npcs[npc_id] += 1
	if !defeated_npcs.has(npc_id): defeated_npcs[npc_id] = 0
	if won: defeated_npcs[npc_id] += 1


func has_fought(npc_id: StringName) -> bool:
	return battled_npcs.has(npc_id)


func won(npc_id: StringName) -> bool:
	return defeated_npcs.get(npc_id) and defeated_npcs[npc_id] > 0


func add_card(card: GameCard) -> void:
	player_battle_inventory.append(card)
