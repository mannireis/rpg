extends Node

const SAVE_PATH = "user://save_%d.tres"


func _new_save(slot: int) -> Save:
	GameState.reset()
	
	var data := Save.new()
	
	data.player_name = GameState.player_name
	data.chapter_title = GameState.chapter_name
	data.player_pos = GameState.player_pos
	data.met_npcs = GameState.met_npcs.duplicate(true)
	data.battled_npcs = GameState.battled_npcs.duplicate(true)
	data.defeated_npcs = GameState.defeated_npcs.duplicate(true)
	data.max_hp = GameState.player_battle_inventory.max_hp
	data.hp = GameState.player_battle_inventory.hp
	data.room = "res://scenes/chapters/chapter_01.tscn"
	
	for item in GameState.player_battle_inventory.deck:
		data.deck.append(Vector2i(item.suit, CardDatabase.db[int(item.suit)].find(item)))
	
	for item in GameState.item_inventory:
		data.item_paths.append(item.resource_path)
	
	ResourceSaver.save(data, slot_path(slot))
	
	return data


func slot_path(slot: int) -> String:
	return SAVE_PATH % slot


func has_save(slot: int) -> bool:
	return ResourceLoader.exists(slot_path(slot))


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
	data.play_time += GameState.playtime
	
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
	var path := slot_path(slot)
	var data: Save

	if has_save(slot):
		data = load(path) as Save
	else:
		data = _new_save(slot)

	if data == null:
		push_error("could not load save slot")
		return

	get_tree().paused = false
	ShopUi.visible = false

	GameState.speaking_with = &""
	GameState.battle_running = false
	RoomChangeGlobal.emit_battle = false
	RoomChangeGlobal.enemy_battle_inventory = null

	GameState.player_name = data.player_name
	GameState.chapter_name = data.chapter_title

	GameState.met_npcs.clear()
	for item in data.met_npcs:
		GameState.met_npcs[StringName(item)] = data.met_npcs[item]

	GameState.battled_npcs.clear()
	for item in data.battled_npcs:
		GameState.met_npcs[StringName(item)] = data.battled_npcs[item]

	GameState.defeated_npcs.clear()
	for item in data.defeated_npcs:
		GameState.defeated_npcs[StringName(item)] = int(data.defeated_npcs[item])

	var inv := GameState.player_battle_inventory
	inv.max_hp = data.max_hp
	inv.hp = data.hp
	inv.deck.clear()
	for card_ref in data.deck:
		inv.deck.append(CardDatabase.db[int(card_ref.x)][int(card_ref.y)])

	GameState.item_inventory.clear()
	for item_path in data.item_paths:
		if item_path.is_empty():
			continue
		var item := load(item_path) as Item
		if item != null:
			GameState.item_inventory.append(item)

	GameState.player_pos = data.player_pos
	RoomChangeGlobal.player_pos = data.player_pos
	RoomChangeGlobal.activate = true
	RoomChangeGlobal.scene_return = data.room

	var err := get_tree().change_scene_to_file(data.room)
	if err != OK:
		push_error("Failed to change to saved room: %s" % data.room)
		return

	await get_tree().scene_changed
	await get_tree().process_frame
	apply_world_state(data.world_state)


func delete_save(slot: int) -> void:
	var path := slot_path(slot)
	if not FileAccess.file_exists(path):
		return

	DirAccess.remove_absolute(path)
