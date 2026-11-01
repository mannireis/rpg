extends Node

const SAVE_PATH = "user://save_%d.tres"

func slot_path(slot: int) -> String:
	return SAVE_PATH % slot

func can_save() -> bool:
	var scene := get_tree().current_scene

	if scene == null:
		return false
	if scene.scene_file_path.is_empty():
		return false
	if scene.scene_file_path == "res://scenes/main_menu.tscn":
		return false
	if GameState.battle_running:
		return false

	return true

func save_game(slot: int) -> void:
	if not can_save():
		push_error("GRRR not in a scene")
		return
	
	var data := Save.new()
	
	data.player_name = GameState.player_name
	data.chapter_title = GameState.chapter_name
	data.player_pos = GameState.player_pos
	data.met_npcs = GameState.met_npcs.duplicate(true)
	data.battled_npcs = GameState.battled_npcs.duplicate(true)
	data.defeated_npcs = GameState.defeated_npcs.duplicate(true)
	data.max_hp = GameState.player_battle_inventory.max_hp
	data.hp = GameState.player_battle_inventory.hp
	data.room = get_tree().current_scene.scene_file_path
	
	data.deck.clear()
	data.item_paths.clear()
	
	for item in GameState.player_battle_inventory.deck:
		data.deck.append(Vector2i(item.suit, CardDatabase.db[int(item.suit)].find(item)))
	
	for item in GameState.item_inventory:
		data.item_paths.append(item.resource_path)
	
	for node in get_tree().get_nodes_in_group("saveable"):
		data.world_state[node.save_id()] = node.save_state()
	
	ResourceSaver.save(data, slot_path(slot))


func apply_world_state(world_state: Dictionary) -> void:
	for node in get_tree().get_nodes_in_group("saveable"):
		var id: String = node.save_id()
		if world_state.has(id):
			node.apply_state(world_state[id])


func load_game(slot: int) -> void:
	pass
