extends Node

@onready var player = PlayerCtl.create(get_parent(),[])
@onready var enemy = PlayerCtl.create(get_parent(),[],true)
@onready var snap_points = get_parent().get_node("CanvasLayer/SnapPoints")
@onready var UI = get_parent().get_node("CanvasLayer/UI")

var game_result: Array[bool] = [false,false]


func _ready() -> void:
	var c = UI.get_node("Container")
	
	player.hp_display = c.get_node("PlayerHP")
	player.block_display = c.get_node("PlayerBlock")
	player.equipped_display = UI.get_node("PlayerEquipped")
	player.draw(2,true)
	enemy.hp_display = c.get_node("EnemyHP")
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
