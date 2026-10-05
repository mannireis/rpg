extends Node
@onready var snap_points = get_parent().get_node("CanvasLayer/SnapPoints")
@onready var UI = get_parent().get_node("CanvasLayer/UI")
var player: PlayerCtl
var enemy: PlayerCtl
var game_result: Array[bool] = [false,false]


func _ready() -> void:
	var c = UI.get_node("Container")
	if !GameState.player_battle_inventory: player = PlayerCtl.create(get_parent(),[])
	else:
		var p_inv = GameState.player_battle_inventory
		player = PlayerCtl.create(get_parent(),p_inv.deck)
		player.max_hp = p_inv.max_hp
		player.hp = p_inv.hp
		player.equipped_display = UI.get_node("PlayerEquipped")
		for eq in p_inv.starting_equipped:
			player.permanent_deck.append(eq)
			player.equip_card(len(player.permanent_deck)-1)
		for card in p_inv.starting_hand:
			player.permanent_deck.append(card)
			player.hand.append(len(player.permanent_deck)-1)
	player.hp_display = c.get_node("PlayerHP")
	player.hp_display.text = str(player.hp)+" HP"
	player.block_display = c.get_node("PlayerBlock")
	player.equipped_display = UI.get_node("PlayerEquipped")
	player.draw(2,true)
	if !RoomChangeGlobal.enemy_battle_inventory: enemy = PlayerCtl.create(get_parent(),[],true)
	else:
		var e_inv = RoomChangeGlobal.enemy_battle_inventory
		enemy = PlayerCtl.create(get_parent(),e_inv.deck,true)
		if e_inv.ai_atk_chance != null: enemy.ai_default_atk_chance = e_inv.ai_atk_chance
		if e_inv.ai_block_chance != null: enemy.ai_default_block_chance = e_inv.ai_block_chance
		enemy.max_hp = e_inv.max_hp
		enemy.hp = e_inv.hp
		enemy.equipped_display = UI.get_node("EnemyEquipped")
		for eq in e_inv.starting_equipped:
			enemy.permanent_deck.append(eq)
			enemy.equip_card(len(enemy.permanent_deck)-1)
		for card in e_inv.starting_hand:
			enemy.permanent_deck.append(card)
			enemy.hand.append(len(enemy.permanent_deck)-1)
	enemy.hp_display = c.get_node("EnemyHP")
	enemy.hp_display.text = str(enemy.hp)+" HP"
	enemy.block_display = c.get_node("EnemyBlock")
	enemy.equipped_display = UI.get_node("EnemyEquipped")
	player.turn_begin()


func get_oppo(caller_is_enemy: bool) -> PlayerCtl:
	if caller_is_enemy:
		return player
	else: return enemy #such code, very advance


func call_as_player(method:String, args: Array, is_enemy: bool = false) -> void:
	if !is_enemy:
		enemy.callv(method,args)
	else:
		player.callv(method,args)
		
func eval_hp() -> void:
	#game ended? winner is_enemy?
	if game_result[0]: return
	if enemy.hp <= 0: 
		game_result = [true,true]
		Signals.battle_won.emit()
	elif player.hp <= 0: 
		Signals.battle_lost.emit()
		game_result = [true,false]
	
	if game_result[0]:
		RoomChangeGlobal.player_hp = player.hp
		RoomChangeGlobal.last_battle_result = game_result[1]
		RoomChangeGlobal.emit_battle = true
		print("game ending, enemy won? "+str(game_result[1]))
		await get_tree().create_timer(2).timeout
		get_tree().call_deferred("change_scene_to_file",RoomChangeGlobal.scene_return)
